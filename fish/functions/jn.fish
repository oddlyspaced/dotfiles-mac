function jn --description 'pretty-print piped JSON in nvim (jq -> nvim)'
    jq $argv | nvim -c 'set ft=json' -
end
