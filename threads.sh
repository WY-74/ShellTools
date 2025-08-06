#!/bin/bash

WORKPATH="/sdcard/Download/shelltools/top_threads_cpu"

mkdir -p "$WORKPATH"
rm -rf "$WORKPATH"/*

cleanup() {
    echo ""
    echo "接收到Ctrl+C信号, 正在清理..."
    echo "停止监控进程"
    # 可以在这里添加其他清理操作
    exit 0
}
trap cleanup SIGINT

function verify_process_id() {
    if [ $# -eq 0 ]; then
        echo "No process IDs provided. please provide at least one process ID."
        exit 1
    fi

    for pid in "$@"
    do
        if [ -d "/proc/$pid" ]; then
            continue
        else
            echo "Process ID $pid does not exist."
            exit 1
        fi
    done

    echo "Number of threads: $#"
}

function main() {
    local pids=$(IFS=,; echo "$*")
    top -p $pids -b -d1 > "$WORKPATH/info.txt"
}

verify_process_id "$@"
main "$@"
