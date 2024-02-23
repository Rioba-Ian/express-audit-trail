import { Client, Pool } from "pg";
// import { Kysely, PostgresDialect } from "kysely";
import fs from "fs";
import { config } from "../../config";

const pool = new Pool({
 user: config.PGUSER,
 host: config.PGHOST,
 database: config.PGDATABASE,
 password: config.PGPASSWORD,
 max: 20,
 idleTimeoutMillis: 30000,
 connectionTimeoutMillis: 20000,
 ssl: true,
});
console.log("Database pool connected.");

pool.connect((err, client, release) => {
 if (err) {
  console.error("Error connecting to pool:", err);
  return;
 }

 console.log("Connected to database pool.");

 release();
});

pool.on("error", (err) => {
 console.error("Unexpected error on idle client", err);
 process.exit(-1);
});

// creating tables query runs once
// const createTablesQuery = fs.readFileSync(
//  "./src/lib/queries/tables.sql",
//  "utf-8"
// );

// pool
//  .query(createTablesQuery)
//  .then(() => {
//   console.log("Tables created successfully.");
//  })
//  .catch((err) => {
//   console.error("Error creating tables.", err);
//  });

export default pool;
