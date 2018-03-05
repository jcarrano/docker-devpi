#!/bin/sh

export DEVPI_SERVERDIR="/data/server"
export DEVPI_CLIENTDIR="/data/client"

initialise_devpi() {
    echo "[RUN]: Initialise devpi-server"

    if [ x"${DEVPI_PASSWORD}" = x ] ; then
        echo "[RUN]: Please choose a password. Exiting."
        return 1
    fi

    echo "${DEVPI_PASSWORD}
${DEVPI_PASSWORD}" | \
     devpi-server --restrict-modify root \
                 --init --passwd root
}

die() {
   echo "[RUN] Unrecoverable error."
   exit 1
}

echo "DEVPI_SERVERDIR is ${DEVPI_SERVERDIR}"
echo "DEVPI_CLIENTDIR is ${DEVPI_CLIENTDIR}"

if [ "$1" = 'devpi' ]; then
    if [ ! -f  $DEVPI_SERVERDIR/.serverversion ]; then
        initialise_devpi || die
    fi

    echo "[RUN]: Launching devpi-server"
    exec devpi-server --restrict-modify root --host 0.0.0.0 --port 3141 --debug
fi

echo "[RUN]: Builtin command not provided [devpi]"
echo "[RUN]: $@"

exec "$@"
