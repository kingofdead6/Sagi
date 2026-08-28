/** Human order reference: "DR" + 6 digits (e.g. DR123326). */
export function generateOrderCode(): string {
  const n = Math.floor(Math.random() * 1_000_000);
  return `DR${n.toString().padStart(6, '0')}`;
}

/**
 * Generates a code that passes `exists`, retrying on collision.
 * Throws after `attempts` tries rather than looping forever.
 */
export async function generateUniqueOrderCode(
  exists: (code: string) => Promise<boolean>,
  attempts = 12,
): Promise<string> {
  for (let i = 0; i < attempts; i += 1) {
    const code = generateOrderCode();
    if (!(await exists(code))) return code;
  }
  throw new Error('Could not generate a unique order code');
}
