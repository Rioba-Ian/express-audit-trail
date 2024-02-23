import { Client } from "pg";

export const client = new Client({
 user: "",
 host: "localhost",
 database: "user_audit_trail",
 password: "pass123",
 port: 5432,
});

client
 .connect()
 .then(() => {
  console.log("Database client connected.");
 })
 .catch((err) => {
  console.error(`Error connecting to database ${err}`);
 });
