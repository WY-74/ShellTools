#!/bin/sh

WORKPATH="/sdcard/Download/shelltools/top_threads_cpu"

mkdir -p "$WORKPATH"
rm -rf "$WORKPATH"/*

cleanup() {
    echo ""
    echo "Stopping monitoring and calculating...\n"

    get_thread_ids
    calculate

    exit 0
}

trap cleanup SIGINT

function verify_process_id() {
    if [ $# -eq 0 ] || [ $# -gt 1 ]; then
        echo "please provide one process id."
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

    echo "Start monitoring process IDs: $*"
}

function save() {
    local pids=$(IFS=,; echo "$*")
    top -p $pids -b -d 1 -H > "$WORKPATH/info.txt"
}

function get_thread_ids() {
    local tids=$(awk '
        /^[[:space:]]*[0-9]+[[:space:]]+[^[:space:]]+/ {
            tid = $1
            count[tid]++
        }
        END {
            print "\tTID\tCounts:"
            for (id in count) {
                print "\t" id "\t" count[id]
            }
        }
    ' $WORKPATH/info.txt)

    # echo "Thread IDs and their counts:"
    # echo "$tids\n"

    tid_array=($(echo "$tids" | awk 'NR>1 {print $1}'))
}

function calculate() {
    echo "TID\tCounts\tAvg\tMax\tMin"
    for tid in "${tid_array[@]}"
    do
        result=$(cat "$WORKPATH/info.txt" \
        | awk -v target_id="$tid" '$1 == target_id' \
        | awk '
        NR==1{max=min=$9} {sum+=$9; count++; if($9>max) max=$9; if($9<min) min=$9} END {if(count>0) printf "%d %.2f %.2f %.2f\n", count, sum/count, max, min; else printf "%d 0.00 0.00 0.00\n", count}'
        )
        read count avg max min <<< "$result"
        echo -e "$tid\t$count\t$avg%\t$max%\t$min%"
    done
}

function main() {
    verify_process_id "$@"
    save "$@"
}

main "$@"
