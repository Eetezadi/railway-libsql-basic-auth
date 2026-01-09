import { defineConfig } from 'drizzle-kit';
import 'dotenv/config';

const dbUrl = process.env.DB_URL || '';
const authToken = process.env.DATABASE_AUTH_TOKEN || '';

export default defineConfig({
  schema: './src/db/schema.ts',
  out: './src/db/migrations',
  dialect: 'turso',
  dbCredentials: {
    url: `libsql://${dbUrl}`,
    authToken,
  },
});
