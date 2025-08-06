adb root
adb push threads.sh /sdcard/Download
adb shell "chmod 777 /sdcard/Download/threads.sh"
adb shell "sh /sdcard/Download/threads.sh 2 3"