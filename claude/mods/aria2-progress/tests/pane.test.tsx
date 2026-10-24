import { expect, mock, test } from 'claude-code/testing'

const PANE = {
  plugin: 'aria2-progress',
  component: 'Pane',
  requestId: 'aria2-progress',
  props: {
    title: 'aria2c',
    isFocused: false,
    bodyColumns: 48,
    placement: 'dock',
    scroll: { offset: 0, bodyRows: 30 },
    view: {},
  },
} as const

const file = (gid: string, status: string, name: string, total: number, done: number, speed: number) => ({
  gid, status, totalLength: String(total), completedLength: String(done),
  downloadSpeed: String(speed), connections: '16', files: [{ path: `/dl/${name}` }],
})

const RPC = JSON.stringify({
  result: [
    [[file('a1', 'active', 'PixelOS_lemonadep-16.2-20260702-0944.zip', 2615610179, 1200000000, 31000000)]],
    [[file('b2', 'waiting', 'boot.img', 201326592, 0, 0)]],
    [[file('c3', 'complete', 'dtbo.img', 25165824, 25165824, 0), { ...file('d4', 'error', 'vendor_boot.img', 0, 0, 0), errorMessage: 'HTTP 403' }]],
  ],
})

test('the pane draws active, queued and finished downloads on every surface', async ($, on) => {
  const clock = mock.clock(on)
  on('command.register', () => ({ value: { command: 'aria2' } }))
  on('ui.open', () => ({ value: { isPlaced: true } }))
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  on('env.get', () => ({ value: undefined }))
  on('http.fetch', () => ({ value: { status: 200, ok: true, headers: {}, text: RPC } }))

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await clock.advance(3100)

  for (const surface of ['terminal', 'desktop', 'vscode', 'mobile'] as const) {
    const ui = await $.ui.mount({ ...PANE, surface })
    await ui.drawn()
    expect((await ui.find({ type: 'Text', text: /^45%$/ }))?.text).toBe('45%')
    expect(await ui.find({ type: 'Text', text: /Queued · 1/ })).toBeDefined()
    expect(await ui.find({ type: 'Text', text: /failed/ })).toBeDefined()
    if (surface === 'terminal') console.log(JSON.stringify(await ui.drawn()).slice(0, 3000))
    await ui.unmount()
  }
})

test('the pane says how to start aria2c when RPC is down', async ($, on) => {
  const clock = mock.clock(on)
  on('command.register', () => ({ value: { command: 'aria2' } }))
  on('ui.open', () => ({ value: { isPlaced: true } }))
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  on('env.get', () => ({ value: undefined }))
  on('http.fetch', () => ({ value: { status: 502, ok: false, headers: {}, text: '' } }))

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await clock.advance(1100)
  const ui = await $.ui.mount({ ...PANE, surface: 'terminal' })
  expect(await ui.find({ type: 'Text', text: /not reachable/ })).toBeDefined()
  await ui.unmount()
})
