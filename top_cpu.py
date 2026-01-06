from dataclasses import dataclass


@dataclass
class CpuInfo:
    count: int
    sum: float
    max: float
    min: float
    avg: float = 0.0


num = 1
skip_rows = 5

with open("cpus.txt") as f:
    data = f.read()
data = [line for line in data.splitlines() if line.strip()]

i = 0
valid_rows = []
while i < len(data):
    valid_rows += data[i + skip_rows : i + skip_rows + num]
    i += skip_rows + num

_map = {}
for row in valid_rows:
    pid = int(row.split()[0])
    cpu_usage = float(row.split()[8])

    if pid not in _map:
        _map[pid] = CpuInfo(count=1, sum=cpu_usage, max=cpu_usage, min=cpu_usage)
    else:
        _map[pid].count += 1
        _map[pid].sum += cpu_usage
        _map[pid].max = max(_map[pid].max, cpu_usage)
        _map[pid].min = min(_map[pid].min, cpu_usage)
        _map[pid].avg = round(_map[pid].sum / _map[pid].count, 2)

print(_map)
