/**
 * Phone is the identity in Saji. Algerian mobile numbers only:
 * local 0[5-7]XXXXXXXX  <->  E.164 +2135XXXXXXXX
 */

const LOCAL_RE = /^0[5-7]\d{8}$/;
const E164_RE = /^\+213[5-7]\d{8}$/;

export function isValidAlgerianPhone(input: string): boolean {
  const cleaned = stripSeparators(input);
  return LOCAL_RE.test(cleaned) || E164_RE.test(cleaned) || /^213[5-7]\d{8}$/.test(cleaned);
}

function stripSeparators(input: string): string {
  return input.replace(/[\s\-().]/g, '');
}

/** Normalizes any accepted form to E.164 (+213…). Throws when invalid. */
export function normalizePhone(input: string): string {
  const cleaned = stripSeparators(input ?? '');
  if (E164_RE.test(cleaned)) return cleaned;
  if (/^213[5-7]\d{8}$/.test(cleaned)) return `+${cleaned}`;
  if (LOCAL_RE.test(cleaned)) return `+213${cleaned.slice(1)}`;
  throw new Error(`Invalid Algerian phone number: ${input}`);
}

/** E.164 back to the local 0… form used in the Algerian UI. */
export function toLocalPhone(e164: string): string {
  if (E164_RE.test(e164)) return `0${e164.slice(4)}`;
  return e164;
}
