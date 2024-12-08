module.exports = {
  HOST: process.env.POSTGRES_DB_HOST || "postgres-main-postgresql-writer.default.svc.cluster.local",
  USER: process.env.POSTGRES_DB_USER || "postgres",
  PASSWORD: process.env.POSTGRES_DB_PASSWORD || "WVLwwWGX9GcX6TDX",
  DB: process.env.POSTGRES_DB_NAME || "postgres",
  dialect: "postgres",
  pool: {
    max: parseInt(process.env.DB_POOL_MAX, 10) || 5,
    min: parseInt(process.env.DB_POOL_MIN, 10) || 0,
    acquire: parseInt(process.env.DB_POOL_ACQUIRE, 10) || 30000,
    idle: parseInt(process.env.DB_POOL_IDLE, 10) || 10000,
  },
};
