/**
 * Uniform random sampler — baseline strategy.
 * Draws one value from each axis with equal probability.
 */

import { readFileSync } from "fs";
import { parse } from "yaml";
import { createHash } from "crypto";

interface Sample {
  seed: string;
  theme: string;
  palette: string;
  typography: string;
  layout: string;
  density: string;
  motionIntensity: number;
  industry: string;
  persona: string;
  pageArchetype: string;
}

function seededRandom(seed: string): () => number {
  let hash = createHash("sha256").update(seed).digest();
  let offset = 0;
  return () => {
    if (offset + 4 > hash.length) {
      hash = createHash("sha256").update(hash).digest();
      offset = 0;
    }
    const value = hash.readUInt32BE(offset) / 0xffffffff;
    offset += 4;
    return value;
  };
}

function pick<T>(items: T[], rand: () => number): T {
  return items[Math.floor(rand() * items.length)];
}

export function sample(seed: string, themesDir: string, businessDir: string): Sample {
  const rand = seededRandom(seed);

  const themes = readdirSync(themesDir)
    .filter((d) => !d.startsWith("_") && statSync(`${themesDir}/${d}`).isDirectory());

  const theme = pick(themes, rand);
  const themeDir = `${themesDir}/${theme}`;

  const palettes = parse(readFileSync(`${themeDir}/palette.yaml`, "utf8")).palettes;
  const typeSystems = parse(readFileSync(`${themeDir}/typography.yaml`, "utf8")).systems;
  const layouts = parse(readFileSync(`${themeDir}/layout-grammar.yaml`, "utf8")).grammars;
  const densities = Object.keys(
    parse(readFileSync(`${themeDir}/layout-grammar.yaml`, "utf8"))["density-tiers"]
  );

  const industries = parse(readFileSync(`${businessDir}/industries.yaml`, "utf8"));
  const personas = parse(readFileSync(`${businessDir}/personas.yaml`, "utf8"));
  const pages = parse(readFileSync(`${businessDir}/page-archetypes.yaml`, "utf8"));

  return {
    seed,
    theme,
    palette: pick(palettes, rand).name,
    typography: pick(typeSystems, rand).name,
    layout: pick(layouts, rand).name,
    density: pick(densities, rand),
    motionIntensity: Math.round(rand() * 10) / 10,
    industry: pick(industries, rand).id,
    persona: pick(personas, rand).id,
    pageArchetype: pick(pages, rand).id,
  };
}
