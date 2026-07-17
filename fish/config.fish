if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ── PATH ──────────────────────────────────────────────────────────────────────
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/ruby@4.0/bin
fish_add_path /opt/homebrew/opt/openjdk@17/bin
fish_add_path $HOME/.local/bin  # user-local binaries (lvim, uv tools, ...)
fish_add_path $HOME/go/bin      # Go tools (gopls, goimports)

# ── Prompt ────────────────────────────────────────────────────────────────────
starship init fish | source

# ── Environment ───────────────────────────────────────────────────────────────
export EDITOR=nvim
export ANDROID_HOME=$HOME/Library/Android/sdk

# ── Secrets (not tracked in git) ──────────────────────────────────────────────
# Machine-local credentials live in ~/.config/fish/secrets.fish.
# Copy secrets.fish.example -> secrets.fish and fill it in. See README.
test -f $HOME/.config/fish/secrets.fish; and source $HOME/.config/fish/secrets.fish

# ── OrbStack (command-line tools + integration) ───────────────────────────────
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
