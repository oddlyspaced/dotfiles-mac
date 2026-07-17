function claude --description 'Run default claude with CLAUDE_CONFIG_DIR cleared'
    env -u CLAUDE_CONFIG_DIR (command -v claude) $argv
end
