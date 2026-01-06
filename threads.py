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
@click.option('--tids', '-t', required=True, help='Thread IDs to analyze (comma-separated)')
@click.option('--file', '-f', required=True, type=click.Path(exists=True), help='Path to threads data file')
def main(tids, file):
    tids = [int(tid) for tid in tids.split(',')]

    with open(file) as f:
        data = f.read()
    data = [line for line in data.splitlines() if line.strip()]

    _map = {}
    for row in data:
        if row.split()[0].isdigit() and int(row.split()[0]) in tids:
            tid = int(row.split()[0])
            cpu_usage = float(row.split()[8])

            if tid not in _map:
                _map[tid] = CpuInfo(count=1, sum=cpu_usage, max=cpu_usage, min=cpu_usage)
            else:
                _map[tid].count += 1
                _map[tid].sum += cpu_usage
                _map[tid].max = max(_map[tid].max, cpu_usage)
                _map[tid].min = min(_map[tid].min, cpu_usage)
                _map[tid].avg = round(_map[tid].sum / _map[tid].count, 2)

    print(_map)


if __name__ == "__main__":
    main()
