import dotenv from "dotenv";

dotenv.config({
 path: `./src/.env`,
});

import express from "express";
import pool from "./lib/database";

const app = express();
app.use(express.json());

const port = process.env.PORT || 3000;

app.get("/healthcheck", (req, res) => {
 res.send("Ok.");
});

app.get("/audit-trail/:userId", async (req, res) => {
 const { userId } = req.params;

 try {
  const client = await pool.connect();

  await client.query("BEGIN");

  await client.query("SET search_path = user_audit_trail;");
  // Get audit trail data
  const { rows } = await client.query(
   `    
        WITH RECURSIVE transfer_chain (transactionId, userId, previous_transactionId) AS (
          SELECT
            transactionId,
            receiverId AS userId,
            CAST(NULL AS INTEGER) AS previous_transactionId
          FROM Transactions
          WHERE transactionType = 'transfer'
          AND receiverId = $1
          UNION ALL
          SELECT
            t.transactionId,
            t.senderId AS userId,
            tc.transactionId AS previous_transactionId
          FROM Transactions t
          JOIN transfer_chain tc ON t.transactionType = 'transfer'
          AND t.senderId = tc.userId
        )
        SELECT
          t.transactionId AS user_transaction_id,
          tc.transactionId AS source_transaction_id,
          tc.userId AS source_user_id,
          t.fullTimestamp AS received_date,
          t.fullTimestamp AT TIME ZONE 'UTC' AS transfer_date,
          senderAmount,
          receiverAmount,
          senderCurrency,
          receiverCurrency
        FROM Transactions t
        JOIN transfer_chain tc ON t.transactionId = tc.transactionId
        WHERE t.receiverId = $1
        OR t.senderId = $1
        ORDER BY t.fullTimestamp ASC;
        `,
   [userId]
  );

  await client.query("COMMIT");

  // get the audit trail data and also find way to get final balance

  // Calculate final balance
  const balance = rows.reduce((acc, transaction) => {
   if (transaction.transactionType === "deposit") {
    acc += transaction.receiverAmount;
   } else if (transaction.transactionType === "withdrawal") {
    acc -= transaction.senderAmount;
   } else if (
    transaction.transactionType === "transfer" &&
    transaction.receiverId === userId
   ) {
    acc += transaction.receiverAmount;
   }
   return acc;
  }, 0);

  client.release();

  res.json({
   auditTrail: rows,
   finalBalance: balance,
  });
 } catch (error) {
  console.error(error);
  res.status(500).json({ message: "Internal server error" });
 }
});

app.listen(port, () => {
 console.log(`Server running on http://localhost:${port}`);
});
