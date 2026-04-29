import { ConnectionOptions } from 'typeorm';
import { SnakeNamingStrategy } from 'typeorm-naming-strategies';

// Check if we are running in production mode
const isProduction = process.env.NODE_ENV === 'production';
const fileExtension = isProduction ? 'js' : 'ts';
const baseDir = isProduction ? 'dist' : 'src';

const config: ConnectionOptions = {
  type: 'postgres',
  name: 'default',
  host: process.env.PG_HOST,
  port: Number(process.env.PG_PORT),
  username: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DB,
  synchronize: false,
  logging: false,
  // This line is the magic fix:
  entities: [`${baseDir}/orm/entities/**/*.${fileExtension}`],
  migrations: [`${baseDir}/orm/migrations/**/*.${fileExtension}`],
  subscribers: [`${baseDir}/orm/subscriber/**/*.${fileExtension}`],
  cli: {
    entitiesDir: 'src/orm/entities',
    migrationsDir: 'src/orm/migrations',
    subscribersDir: 'src/orm/subscriber',
  },
  namingStrategy: new SnakeNamingStrategy(),
  // Add SSL for AWS RDS
  ssl: isProduction ? { rejectUnauthorized: false } : false,
};

export = config;