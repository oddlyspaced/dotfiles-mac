export type Download = {
  gid: string
  name: string
  status: 'active' | 'waiting' | 'paused' | 'error' | 'complete' | 'removed'
  total: number
  done: number
  speed: number
  connections: number
  error?: string
}

export type Snapshot = {
  isReachable: boolean
  downloads: Download[]
  speed: number
  // Total download speed, one sample per poll, oldest first.
  history: number[]
  at: number
}

declare module 'claude-code' {
  interface PluginState {
    'aria2-progress': { snapshot: Snapshot }
  }
}
