#!/bin/sh

BIN_DIR=`dirname $0`
PROJECTS_ROOT=`readlink -f "${BIN_DIR}/../projects"`
BACKEND_ROOT=`readlink -f "${PROJECTS_ROOT}/backend"`
FRONTEND_ROOT=`readlink -f "${PROJECTS_ROOT}/frontend"`

if [ "$(whoami)" = "devel" ]; then
    if [ ! -d ~/.virtualenvs/imaginevr ]; then
        vex --make imaginevr pip install -U pip
    fi
    . ~/.virtualenvs/imaginevr/bin/activate
fi
"${BACKEND_ROOT}/bin/setup.sh"

tmux new-session -s "onelove" -d "${BACKEND_ROOT}/bin/dev.sh"
tmux splitw -h -p 50 -t 0 -c "${FRONTEND_ROOT}" "${FRONTEND_ROOT}/bin/dev.sh"
tmux splitw -v -p 50 -t 0 -c "${BACKEND_ROOT}" "${BACKEND_ROOT}/bin/worker_dev.sh"
tmux a
