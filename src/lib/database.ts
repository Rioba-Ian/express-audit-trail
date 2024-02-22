import { Pool } from "pg";

export const pool = new Pool({
 user: "",
 host: "",
 password: "",
 database: "user_audit_trail",
 port: 5432,
});
