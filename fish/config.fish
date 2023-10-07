if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/openjdk/bin

starship init fish | source

export EDITOR=nvim
