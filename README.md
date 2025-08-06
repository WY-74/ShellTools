# ShellTools

## dumpsys_meminfo.sh
基于 `dumpsys meminfo` 实现

计算一段时间内进程RSS均值

## top_cpu.shtop_cpu.sh
基于 `top` 实现
计算一段时间内进程CPU均值，最大值和最小值

## threads.sh
基于 `top -H` 实现

计算一段时间内，某进程的各线程CPU均值，最大值和最小值

eg: `sh threads.sh 1`
