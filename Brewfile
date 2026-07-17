# Brewfile — install everything with:  brew bundle --file=Brewfile
# Regenerate from the current machine with:  brew bundle dump --force --file=Brewfile
#
# Only top-level packages are listed (dependencies are resolved automatically).

# ── Taps ──────────────────────────────────────────────────────────────────────
tap "asmvik/formulae"        # yabai + skhd (maintained fork)
tap "felixkratz/formulae"    # sketchybar + borders (JankyBorders)
tap "mobile-dev-inc/tap"     # maestro (mobile UI test runner)
tap "netbirdio/tap"          # netbird (WireGuard-based mesh VPN)

# ── Window management / desktop (the ricing stack) ────────────────────────────
brew "asmvik/formulae/yabai"          # tiling window manager
brew "asmvik/formulae/skhd"           # hotkey daemon (keybindings)
brew "felixkratz/formulae/sketchybar" # custom menu bar
brew "felixkratz/formulae/borders"    # JankyBorders — active-window borders

# ── Shell / prompt / CLI ──────────────────────────────────────────────────────
brew "fish"        # shell
brew "starship"    # prompt
brew "neovim"      # editor (LazyVim config lives in nvim/)
brew "tree"
brew "glow"        # markdown renderer
brew "gotop"       # terminal system monitor
brew "neofetch"

# ── Dev tooling ───────────────────────────────────────────────────────────────
brew "gh"          # GitHub CLI
brew "git-lfs"
brew "go"
brew "uv"          # Python package/venv manager
brew "openjdk@17"
brew "yarn"
brew "xcodegen"    # generate .xcodeproj from spec
brew "cocoapods"
brew "fastlane"    # iOS/Android release automation

# ── Mobile / Android ──────────────────────────────────────────────────────────
brew "apktool"     # APK reverse-engineering
brew "scrcpy"      # mirror/control Android devices
brew "mobile-dev-inc/tap/maestro"

# ── Data / services ───────────────────────────────────────────────────────────
brew "redis"
brew "mongosh"
brew "railway"     # Railway deploy CLI
brew "netbirdio/tap/netbird"

# ── Media / image utilities ───────────────────────────────────────────────────
brew "imagemagick"
brew "pngquant"
brew "poppler"     # PDF utilities
brew "yt-dlp"

# ── Fonts ─────────────────────────────────────────────────────────────────────
cask "font-fantasque-sans-mono-nerd-font"  # sketchybar / ghostty UI font
cask "font-jetbrains-mono-nerd-font"
cask "font-jetbrains-mono"
cask "font-hack-nerd-font"
cask "font-sketchybar-app-font"            # app glyphs for sketchybar spaces

# ── Keyboard / menu-bar utilities ─────────────────────────────────────────────
cask "hyperkey"          # remap Caps Lock -> Hyper (⌘⌥⌃⇧) for skhd
cask "raycast"           # launcher / hotkeys
cask "stats"             # menu-bar system monitor
cask "macs-fan-control"
cask "claude-island"     # notch status for Claude Code (see claude/hooks)
cask "vibe-notch"        # notch utility

# ── Terminals / editors / IDEs ────────────────────────────────────────────────
cask "ghostty"           # primary terminal (config in ghostty/)
cask "cursor"
cask "android-studio"
cask "android-platform-tools"

# ── AI tooling ────────────────────────────────────────────────────────────────
cask "claude-code@latest"

# ── Browsers / networking / proxy ─────────────────────────────────────────────
cask "google-chrome"
cask "cloudflare-warp"
cask "tailscale-app"
cask "ngrok"
cask "proxyman"
cask "mitmproxy"

# ── Design ────────────────────────────────────────────────────────────────────
cask "figma"

# ── Databases / analytics GUIs ────────────────────────────────────────────────
cask "postico"           # Postgres client
cask "superset"

# ── Productivity / notes / media ──────────────────────────────────────────────
cask "slack"
cask "granola"           # AI meeting notes
cask "spotify"
cask "iina"              # media player
cask "orbstack"          # Docker/Linux VMs
cask "blip"              # file transfer
cask "cap"               # screen recorder
cask "rockxy"
