# Ccpu

计算进程或线程的cpu信息

## 使用手册
### Process

首先我们需要通过 `top` 指令保存数据( `-b` 参数是必须的)

指令: `python process.py -n {n} -f {path to file}` 
- -f: 指定进程数据存放位置
- -n: 指明进程数

该模块将在指定的file下分别计算所有进程的cpu信息

### Threads
首先我们需要通过 `top` 指令保存数据( `-b` 参数是必须的)


指令: `python threads.py -t {tid1,tid2} -f {path to file}`
- -f: 指定线程数据存放位置
- -t: 指明需要计算的线程id(tid)

该模块将在指定的file下分别计算指定tid的cpu信息