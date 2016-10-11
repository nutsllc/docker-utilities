#!/bin/bash

packages=()
[ "${NMAP}" = "enable" ] && {
    packages=(nmap ${packages[@]})
}
[ "${APACHE2_UTILS}" = "enable" ] && {
    packages=(apache2-utils ${packages[@]})
}
[ "${MYSQL_CLIENT}" = "enable" ] && {
    packages=(mysql-client ${packages[@]})
}
[ "${SQLITE}" = "enable" ] && {
    packages=(sqlite ${packages[@]})
}

[ ${#packages[@]} -ne 0 ] && {
    sudo apk update
    for pkg in ${packages[@]}; do
        sudo apk add --no-cache ${pkg}
    done
}

exec $@
