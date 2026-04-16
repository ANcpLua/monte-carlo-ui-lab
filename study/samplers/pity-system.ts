/**
 * Pity system — bad luck protection for trial generation.
 * Tightens constraints on each reroll until a guaranteed-pass fallback.
 */

import { readFileSync } from "fs";
import { parse } from "yaml";

interface AuditResult {
  a11y_score: number;
  contrast_min: number;
  lcp_ms: number;
  cls: number;
  cohesion: number;
  pattern_compliance: number;
  copy_realism: number;
}

interface Thresholds {
  a11y_score: number;
  contrast_min: number;
  lcp_max_ms: number;
  cls_max: number;
  cohesion_min: number;
  pattern_compliance: number;
  copy_realism: number;
}

interface TrialConfig {
  hybridRatio: [number, number] | null; // [primary%, secondary%] or null for intra-theme
  variationRange: number; // 0.0 (minimal) to 1.0 (full)
}

export function passesFloor(audit: AuditResult, thresholds: Thresholds): boolean {
  return (
    audit.a11y_score >= thresholds.a11y_score &&
    audit.contrast_min >= thresholds.contrast_min &&
    audit.lcp_ms <= thresholds.lcp_max_ms &&
    audit.cls <= thresholds.cls_max &&
    audit.cohesion >= thresholds.cohesion_min &&
    audit.pattern_compliance >= thresholds.pattern_compliance &&
    audit.copy_realism >= thresholds.copy_realism
  );
}

export function tighten(attempt: number, original: TrialConfig): TrialConfig {
  switch (attempt) {
    case 1:
      return original;

    case 2:
      if (original.hybridRatio) {
        return { hybridRatio: [85, 15], variationRange: original.variationRange * 0.7 };
      }
      return { hybridRatio: null, variationRange: original.variationRange * 0.5 };

    case 3:
    default:
      return { hybridRatio: null, variationRange: 0.1 };
  }
}

export function loadThresholds(path: string): Thresholds {
  const raw = parse(readFileSync(path, "utf8"));
  return raw.floors;
}
