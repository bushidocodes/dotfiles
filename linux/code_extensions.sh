#!/bin/bash

source "../utils.sh"

file_location="./code_extensions.txt"

pull(){
    extensions=$(list_code_extensions)
    rm "$file_location" 2> /dev/null
    for extension in $extensions; do
        echo "$extension" >> "$file_location"
    done
}

push(){
    while IFS= read -r extension
    do
        install_code_extension "$extension"
    done < "$file_location"
}

main(){
    command=$1
    case $command in
    pull)
        pull
    ;;
    push)
        push
    ;;
    esac
}

main "$@"