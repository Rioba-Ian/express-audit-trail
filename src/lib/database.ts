import { Client } from "pg";
import fs from "fs";

const createClient = (): Client => {
 const client = new Client({
  user: "postgres",
  host: "localhost",
  database: "user_audit_trail",
  password: "pass123",
  port: 65432,
 });

 client
  .connect()
  .then(() => {
   console.log("Database client connected.");

   // read queries from create tables query
   const createTablesQuery = fs.readFileSync("./src/lib/tables.sql", "utf-8");

   client
    .query(createTablesQuery)
    .then(() => {
     console.log("Tables created successfully.");
     client.end();
    })
    .catch((err) => {
     console.error("Error creating tables:", err);
     client.end();
    });
  })
  .catch((err) => {
   console.error(`Error connecting to database ${err}`);
  });

 return client;
};

export default createClient;
