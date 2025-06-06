WORKPATH="/sdcard/Download/shelltools/dumpsys_meminfo"
PROCESS_NAMES=(
    "com.wanos.media"
    "android.hardware.media.c2@1.2-wanos-service"
    "android.hardware.audio.service"
)

mkdir -p "$WORKPATH"
rm -rf "$WORKPATH"/*

function save_and_count(){
    i=0
    sum=0
    while [ $i -lt 120 ]
    do
        current=$(dumpsys meminfo "$1" | tee -a "$WORKPATH/$1.txt" | grep "TOTAL RSS" | awk '{print $6}')
        echo -e "\n\n\n" >> "$WORKPATH/$1.txt"

        i=$((i+1))
        sum=$((sum + current))
        sleep 1
    done
    echo "Average RSS for ($2): $(awk "BEGIN {printf \"%.2f\", $sum / 120 / 1024}") MB"
}

for arg in "${PROCESS_NAMES[@]}"
do
    pid=$(ps -A | grep "${arg}$" | awk '{print $2}')
    save_and_count "$pid" "$arg"
done
