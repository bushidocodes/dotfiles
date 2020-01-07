#!/usr/bin/env bash

# A utility to help keep my VSCode settings file in sync between WSL and Windows
main () {
    declare command=$1

    case $command in
        diff)
            diff ../vscode_settings.json ~/winhome/AppData/Roaming/Code/User/settings.json
            ;;
        push)
            cp ../vscode_settings.json ~/winhome/AppData/Roaming/Code/User
            ;;
        pull)
            cp -f ~/winhome/AppData/Roaming/Code/User/settings.json ../vscode_settings.json
            ;;
    esac
}

main "$@"