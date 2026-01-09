import { createClient } from '@libsql/client';
import { drizzle } from 'drizzle-orm/libsql';
import * as schema from './schema.js';

export function createDbClient(url: string, authToken: string) {
  const client = createClient({
    url: `https://${url}`,
    authToken,
  });

  return drizzle(client, { schema });
}

export type DbClient = ReturnType<typeof createDbClient>;
export { schema };
