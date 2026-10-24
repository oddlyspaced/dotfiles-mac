import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { Download, Snapshot } from '../types'

const PANE = 'aria2-progress'
const TITLE = 'aria2c'
const DEFAULT_URL = 'http://127.0.0.1:6800/jsonrpc'
const HISTORY = 60
const KEYS = [
  'gid',
  'status',
  'totalLength',
  'completedLength',
  'downloadSpeed',
  'connections',
  'files',
  'errorMessage',
]

// Catppuccin Mocha, to match the Ghostty theme.
const C = {
  base: '#1e1e2e', // the pane background
  accent: '#cba6f7', // mauve
  spark: '#b4befe', // lavender
  text: '#cdd6f4',
  dim: '#a6adc8', // subtext0
  faint: '#7f849c', // overlay1
  track: '#45475a', // surface1
  border: '#585b70', // surface2
  green: '#a6e3a1',
  red: '#f38ba8',
  peach: '#fab387',
  sky: '#89dceb',
} as const

const snapshot = atom({ plugin: 'aria2-progress', key: 'snapshot' } as const, {
  isReachable: false,
  downloads: [],
  speed: 0,
  history: [],
  at: 0,
} as Snapshot)

type RawFile = { path?: string; uris?: { uri: string }[] }
type RawDownload = {
  gid: string
  status: Download['status']
  totalLength: string
  completedLength: string
  downloadSpeed: string
  connections: string
  files?: RawFile[]
  errorMessage?: string
}
type Polled = Omit<Snapshot, 'history'>

function nameOf(raw: RawDownload): string {
  const file = raw.files?.[0]
  const path = file?.path || file?.uris?.[0]?.uri || raw.gid
  return (path.split('?')[0] ?? path).split('/').pop() || raw.gid
}

function toDownload(raw: RawDownload): Download {
  return {
    gid: raw.gid,
    name: nameOf(raw),
    status: raw.status,
    total: Number(raw.totalLength),
    done: Number(raw.completedLength),
    speed: Number(raw.downloadSpeed),
    connections: Number(raw.connections),
    error: raw.errorMessage || undefined,
  }
}

// One system.multicall: active, then queued, then the 10 most recent stopped.
async function poll($: EngineInterface): Promise<Polled> {
  const url = (await $.env.get('ARIA2_RPC_URL')) || DEFAULT_URL
  const secret = await $.env.get('ARIA2_RPC_SECRET')
  const auth = secret ? [`token:${secret}`] : []
  const calls = [
    { methodName: 'aria2.tellActive', params: [...auth, KEYS] },
    { methodName: 'aria2.tellWaiting', params: [...auth, 0, 50, KEYS] },
    { methodName: 'aria2.tellStopped', params: [...auth, -1, 10, KEYS] },
  ]
  const at = await $.clock.now()
  try {
    const res = await $.http.fetch(url, {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({
        jsonrpc: '2.0',
        id: 'claude',
        method: 'system.multicall',
        params: [calls],
      }),
    })
    if (!res.ok) return { isReachable: false, downloads: [], speed: 0, at }
    const results = JSON.parse(res.text).result as RawDownload[][][]
    // Each multicall entry is [list] on success, or a fault object.
    const downloads = results.flatMap(one => (Array.isArray(one) ? (one[0] ?? []) : [])).map(toDownload)
    const speed = downloads.reduce((sum, d) => sum + d.speed, 0)

    return { isReachable: true, downloads, speed, at }
  } catch {
    return { isReachable: false, downloads: [], speed: 0, at }
  }
}

function size(bytes: number): string {
  const units = ['B', 'KB', 'MB', 'GB', 'TB']
  let n = bytes
  let i = 0
  while (n >= 1024 && i < units.length - 1) {
    n /= 1024
    i++
  }
  return `${n.toFixed(i === 0 || n >= 100 ? 0 : 1)} ${units[i]}`
}

function duration(s: number): string {
  if (!Number.isFinite(s) || s < 0) return '--'
  if (s < 60) return `${Math.round(s)}s`
  if (s < 3600) return `${Math.floor(s / 60)}m ${String(Math.round(s % 60)).padStart(2, '0')}s`
  return `${Math.floor(s / 3600)}h ${String(Math.floor((s % 3600) / 60)).padStart(2, '0')}m`
}

function ratio(done: number, total: number): number {
  return total > 0 ? Math.min(1, done / total) : 0
}

// A bar with 1/8-cell resolution: the filled part, then the empty track.
const EIGHTHS = ['', '▏', '▎', '▍', '▌', '▋', '▊', '▉']
function bar(part: number, width: number): [string, string] {
  const cells = part * width
  const full = Math.floor(cells)
  const tip = full < width ? (EIGHTHS[Math.floor((cells - full) * 8)] ?? '') : ''
  const filled = '█'.repeat(full) + tip
  return [filled, '─'.repeat(Math.max(0, width - full - (tip ? 1 : 0)))]
}

const SPARKS = ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█']
function sparkline(values: number[], width: number): string {
  const tail = values.slice(-width)
  const top = Math.max(1, ...tail)
  const line = tail.map(v => (v <= 0 ? ' ' : (SPARKS[Math.min(7, Math.floor((v / top) * 7.99))] ?? ' '))).join('')
  return line.padStart(width, ' ')
}

function totals(list: Download[]) {
  const total = list.reduce((sum, d) => sum + d.total, 0)
  const done = list.reduce((sum, d) => sum + d.done, 0)
  const speed = list.reduce((sum, d) => sum + d.speed, 0)
  return { total, done, speed, part: ratio(done, total) }
}

export const register: Register = on => {
  let activeBefore = 0

  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: 'aria2',
      description: 'Show live aria2c download progress in a pane',
    })

    $.clock.every(1000, async () => {
      const now = await poll($)
      await update($, snapshot, before => ({
        ...now,
        history: [...(before?.history ?? []), now.speed].slice(-HISTORY),
      }))

      const active = now.downloads.filter(d => d.status === 'active')
      if (active.length > 0) {
        const { part } = totals(active)
        $.ui.status(`↓ ${Math.floor(part * 100)}% · ${size(now.speed)}/s · ${active.length} file${active.length > 1 ? 's' : ''}`)
        // Open the pane unasked only when a new batch of downloads starts.
        if (activeBefore === 0) void $.ui.open({ id: PANE, title: TITLE })
      } else if (activeBefore > 0) {
        $.ui.status(undefined)
        $.ui.toast('✓ aria2c: all downloads finished')
      }
      activeBefore = active.length
    })

    return next(e)
  })

  on('command.run', { command: 'aria2' }, async $ => {
    await $.ui.open({ id: PANE, title: TITLE })

    return { text: 'aria2c downloads pane opened.' }
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    const now = await read($, snapshot)
    const columns = Math.max(24, e.props.bodyColumns ?? 60)
    // Paint the whole pane body, so the engine's grey fill never shows.
    const fill = {
      backgroundColor: C.base,
      width: columns,
      minHeight: Math.max(1, e.props.scroll?.bodyRows ?? 1),
    }

    if (!now.isReachable) {
      return (
        <Box {...fill} flexDirection="column" paddingX={1} gap={1}>
          <Text color={C.peach}>○ aria2c is not reachable</Text>
          <Box flexDirection="column">
            <Text color={C.dim}>Start aria2c with RPC on:</Text>
            <Text color={C.accent}>  aria2c --enable-rpc …</Text>
          </Box>
          <Text color={C.dim}>Other port or a secret: set ARIA2_RPC_URL, ARIA2_RPC_SECRET.</Text>
        </Box>
      )
    }

    const active = now.downloads.filter(d => d.status === 'active')
    const queued = now.downloads.filter(d => d.status === 'waiting' || d.status === 'paused')
    const finished = now.downloads.filter(d => d.status === 'complete' || d.status === 'error' || d.status === 'removed')
    const inner = columns - 2

    if (now.downloads.length === 0) {
      return (
        <Box {...fill} paddingX={1}>
          <Text color={C.dim}>● aria2c connected · idle</Text>
        </Box>
      )
    }

    const sum = totals(active)

    return (
      <Box {...fill} flexDirection="column" paddingX={1}>
        {active.length > 0 ? (
          <Box flexDirection="column" borderStyle="round" borderColor={C.border} paddingX={1} marginBottom={1}>
            <Box justifyContent="space-between">
              <Text bold color={C.accent}>{Math.floor(sum.part * 100)}%</Text>
              <Text bold color={C.sky}>↓ {size(sum.speed)}/s</Text>
            </Box>
            <Text color={C.spark}>{sparkline(now.history ?? [], inner - 4)}</Text>
            <Box justifyContent="space-between">
              <Text color={C.dim}>{size(sum.done)} of {size(sum.total)}</Text>
              <Text color={C.dim}>{duration((sum.total - sum.done) / sum.speed)} left</Text>
            </Box>
          </Box>
        ) : (
          <Box marginBottom={1}>
            <Text color={C.green}>✓ All downloads finished</Text>
          </Box>
        )}

        {active.length > 0 && section('Downloading', active.length)}
        {active.map(d => {
          const part = ratio(d.done, d.total)
          const [filled, track] = bar(part, inner)
          return (
            <Box key={d.gid} flexDirection="column" marginBottom={1}>
              <Box justifyContent="space-between" gap={1}>
                <Box flexShrink={1}>
                  <Text bold color={C.text} wrap="truncate-middle">{d.name}</Text>
                </Box>
                <Text bold color={C.accent}>{Math.floor(part * 100)}%</Text>
              </Box>
              <Text>
                <Text color={C.accent}>{filled}</Text>
                <Text color={C.track}>{track}</Text>
              </Text>
              <Box justifyContent="space-between">
                <Text color={C.dim}>{size(d.done)} / {size(d.total)}</Text>
                <Text color={C.dim}>
                  {size(d.speed)}/s · {duration((d.total - d.done) / d.speed)} · {d.connections}×
                </Text>
              </Box>
            </Box>
          )
        })}

        {queued.length > 0 && section('Queued', queued.length)}
        {queued.map(d => (
          <Box key={d.gid} justifyContent="space-between" gap={1}>
            <Box flexShrink={1}>
              <Text color={C.dim} wrap="truncate-middle">{d.status === 'paused' ? '⏸' : '…'} {d.name}</Text>
            </Box>
            <Text color={C.dim}>{d.total > 0 ? size(d.total) : ''}</Text>
          </Box>
        ))}
        {queued.length > 0 && <Box marginBottom={1} />}

        {finished.length > 0 && section('Finished', finished.length)}
        {finished.map(d => (
          <Box key={d.gid} justifyContent="space-between" gap={1}>
            <Box flexShrink={1}>
              <Text wrap="truncate-middle">
                <Text color={d.status === 'complete' ? C.green : C.red}>{d.status === 'complete' ? '✓' : '✗'}</Text>{' '}
                <Text color={d.status === 'complete' ? C.text : C.red}>{d.name}</Text>
              </Text>
            </Box>
            <Text color={C.dim}>{d.status === 'error' ? 'failed' : size(d.total)}</Text>
          </Box>
        ))}
      </Box>
    )

    function section(label: string, count: number) {
      const head = `${label} · ${count} `
      return (
        <Text>
          <Text bold color={C.spark}>{head}</Text>
          <Text color={C.track}>{'─'.repeat(Math.max(0, inner - head.length))}</Text>
        </Text>
      )
    }

  })
}
