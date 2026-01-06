import click
from dataclasses import dataclass


@dataclass
class CpuInfo:
    count: int
    sum: float
    max: float
    min: float
    avg: float = 0.0


@click.command()
@click.option('--num_pids', '-n', required=True, help='Number of PIDs to analyze')
@click.option('--file', '-f', required=True, type=click.Path(exists=True), help='Path to threads data file')
def main(num_pids, file):
    num_pids = int(num_pids)
    skip_rows = 5

    with open(file) as f:
        data = f.read()
    data = [line for line in data.splitlines() if line.strip()]

    i = 0
    valid_rows = []
    while i < len(data):
        valid_rows += data[i + skip_rows : i + skip_rows + num_pids]
        i += skip_rows + num_pids

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


if __name__ == "__main__":
    main()
