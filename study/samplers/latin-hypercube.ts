/**
 * Latin Hypercube sampler — better coverage than uniform for the same sample count.
 * Divides each axis into N equal strata and ensures exactly one sample per stratum per axis.
 */

import { createHash } from "crypto";

interface AxisValues {
  name: string;
  values: string[];
}

interface LHSSample {
  seed: string;
  index: number;
  axes: Record<string, string>;
}

function seededShuffle<T>(items: T[], seed: string, axisIndex: number): T[] {
  const arr = [...items];
  let hash = createHash("sha256").update(`${seed}-${axisIndex}`).digest();
  let offset = 0;

  const nextInt = (max: number) => {
    if (offset + 4 > hash.length) {
      hash = createHash("sha256").update(hash).digest();
      offset = 0;
    }
    const val = hash.readUInt32BE(offset) % max;
    offset += 4;
    return val;
  };

  for (let i = arr.length - 1; i > 0; i--) {
    const j = nextInt(i + 1);
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

export function generateLHS(
  seed: string,
  n: number,
  axes: AxisValues[]
): LHSSample[] {
  const samples: LHSSample[] = [];

  const shuffled = axes.map((axis, i) => {
    const expanded = Array.from({ length: n }, (_, j) =>
      axis.values[j % axis.values.length]
    );
    return seededShuffle(expanded, seed, i);
  });

  for (let i = 0; i < n; i++) {
    const axisMap: Record<string, string> = {};
    axes.forEach((axis, j) => {
      axisMap[axis.name] = shuffled[j][i];
    });
    samples.push({ seed, index: i, axes: axisMap });
  }

  return samples;
}
