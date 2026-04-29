import { ConnectionOptions } from 'typeorm';
import { SnakeNamingStrategy } from 'typeorm-naming-strategies';

const isProduction = process.env.NODE_ENV === 'production';
const fileExtension = isProduction ? 'js' : 'ts';
const baseDir = isProduction ? 'dist' : 'src';

const config: ConnectionOptions = {
  type: 'postgres',
  name: 'default',
  // HARDCODED TO BYPASS BOILERPLATE OVERWRITES:
  host: 'terraform-20260428190342029800000001.cgx20kyocrdg.us-east-1.rds.amazonaws.com',
  port: 5432,
  username: 'dbadmin', 
  password: '8BytePassword2026!', 
  database: 'postgres',
  synchronize: false,
  logging: false,
  entities: [`${baseDir}/orm/entities/**/*.${fileExtension}`],
  migrations: [`${baseDir}/orm/migrations/**/*.${fileExtension}`],
  subscribers: [`${baseDir}/orm/subscriber/**/*.${fileExtension}`],
  cli: {
    entitiesDir: 'src/orm/entities',
    migrationsDir: 'src/orm/migrations',
    subscribersDir: 'src/orm/subscriber',
  },
  namingStrategy: new SnakeNamingStrategy(),
  // Force SSL for RDS
  ssl: { rejectUnauthorized: false },
};

export = config;