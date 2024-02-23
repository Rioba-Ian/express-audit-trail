import { Client } from "pg";

const createClient = (): Client => {
 const client = new Client({
  user: "postgres",
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

 return client;
};

export default createClient;
