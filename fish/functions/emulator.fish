function emulator --description 'List or launch Android emulators (AVDs)'
    set -l sdk_emulator "$HOME/Library/Android/sdk/emulator/emulator"

    if not test -x "$sdk_emulator"
        echo "emulator: SDK binary not found at $sdk_emulator" >&2
        return 1
    end

    switch "$argv[1]"
        case list ls -l --list ''
            $sdk_emulator -list-avds
        case launch start run
            set -l name $argv[2]
            if test -z "$name"
                echo "emulator: give an AVD name, e.g. 'emulator launch Pixel_10_Pro'" >&2
                echo "available:" >&2
                $sdk_emulator -list-avds >&2
                return 1
            end
            # pass through any extra flags after the name
            $sdk_emulator -avd $name $argv[3..-1] &
        case help -h --help
            echo "usage:"
            echo "  emulator list                  list available AVDs"
            echo "  emulator launch <name> [flags] launch an AVD (backgrounded)"
            echo "  emulator help                  show this help"
        case '*'
            # treat a bare name as a launch target: 'emulator Pixel_10_Pro'
            $sdk_emulator -avd $argv &
    end
end
