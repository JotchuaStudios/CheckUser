#!/usr/bin/env bash

# Usage:
#   chmod +x install.sh
#   ./install.sh

# Modificado Por JotchuaStudiosOfficial

url_check_user='https://raw.githubusercontent.com/JotchuaStudios/CheckUser/main/user_check.py'

function download_script() {
    if [[ -e chk.py ]]; then
        service user_check stop
        rm -r chk.py
    fi

    curl -sL -o chk.py $url_check_user
    chmod +x chk.py
    clear
}

function get_version() {
    local version=$(cat chk.py | grep -Eo "__version__ = '([0-9.]+)'" | cut -d "'" -f 2)
    echo $version
}

function check_installed() {
    if [[ -e /usr/bin/checker ]]; then
        clear
        echo 'CheckUser esta instalado'
        read -p 'Desea desinstalar? [s/n]: ' choice

        if [[ $choice =~ ^[Ss]$ ]]; then
            service user_check stop 1>/dev/null 2>&1
            checker --uninstall 1>/dev/null 2>&1
            rm -rf chk.py 1>/dev/null 2>&1
            echo 'CheckUser Desinstalado Con Exito'
        fi
    fi
}

function main() {
    check_installed
    download_script

    if ! [ -f /usr/bin/python3 ]; then
        echo 'Instalando Python3...'
        sudo apt-get install python3
    fi

    read -p 'Que Puerto Quiere Usar?:' -e -i 5000 port

    python3 chk.py --create-service --create-executable --enable-auto-start --port $port --start $mode
}
main $@

