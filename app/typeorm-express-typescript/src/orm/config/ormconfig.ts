import { ConnectionOptions } from 'typeorm';
import { SnakeNamingStrategy } from 'typeorm-naming-strategies';

const isProduction = process.env.NODE_ENV === 'production';
const fileExtension = isProduction ? 'js' : 'ts';
const baseDir = isProduction ? 'dist' : 'src';

const config: ConnectionOptions = {
  type: 'postgres',
  name: 'default',
  // Using process.env to keep secrets out of Git
  host: process.env.PG_HOST,
  port: Number(process.env.PG_PORT) || 5432,
  username: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DB,
  synchronize: false,
  logging: false,
  // Dynamic paths to switch between TS (local) and JS (Docker)
  entities: [`${baseDir}/orm/entities/**/*.${fileExtension}`],
  migrations: [`${baseDir}/orm/migrations/**/*.${fileExtension}`],
  subscribers: [`${baseDir}/orm/subscriber/**/*.${fileExtension}`],
  cli: {
    entitiesDir: 'src/orm/entities',
    migrationsDir: 'src/orm/migrations',
    subscribersDir: 'src/orm/subscriber',
  },
  namingStrategy: new SnakeNamingStrategy(),
  // Added extra safety for RDS SSL connections
  ssl: isProduction || process.env.PGSSLMODE === 'no-verify' 
    ? { rejectUnauthorized: false } 
    : false,
};

export = config;