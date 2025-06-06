WORKPATH="/sdcard/Download/shelltools/top_cpu"
PIDS=()
PROCESS_NAMES=(
    "com.wanos.media"
    "android.hardware.media.c2@1.2-wanos-service"
    "android.hardware.audio.service"
)

mkdir -p "$WORKPATH"
rm -rf "$WORKPATH"/*

function save_and_count(){
    top -p $1 -b -n 120 -d 1 > "$WORKPATH/info.txt"

    for arg in "${PROCESS_NAMES[@]}"
    do
        avg=$(cat "$WORKPATH/info.txt" \
        | grep "${arg}$" \
        | awk 'NR==1{max=min=$9} {sum+=$9; count++; if($9>max) max=$9; if($9<min) min=$9} END {if(count>0) printf "%.2f %.2f %.2f\n", sum/count, max, min; else print "0.00 0.00 0.00"}')
        read avg max min <<< "$avg"

        echo "Average CPU usage for ($arg): $avg% (Max: $max%, Min: $min%)"
    done
}

for arg in "${PROCESS_NAMES[@]}"
do
    pid=$(ps -A | grep "${arg}$" | awk '{print $2}')
    PIDS+=("$pid")
done
save_and_count $(IFS=,; echo "${PIDS[*]}")