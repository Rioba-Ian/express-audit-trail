### 1. SQL query that shall retrieve a user's transaction history with the final balance, considering multi-currency transactions

```sql
SELECT
  t.transactionId,
  t.transactionType,
  t.fullTimestamp,
  senderAmount,
  receiverAmount,
  senderCurrency,
  receiverCurrency,
  (
    CASE
      WHEN t.transactionType IN ('deposit', 'withdrawal') THEN senderAmount
      WHEN t.transactionType = 'transfer' AND receiverId = 1 THEN receiverAmount
      ELSE 0
    END
  ) AS amount_in_user_currency,
  (
    SELECT SUM(
      CASE
        WHEN t1.transactionType IN ('deposit', 'withdrawal') THEN t1.senderAmount
        WHEN t1.transactionType = 'transfer' AND t1.receiverId = 1 THEN t1.receiverAmount
        ELSE 0
      END
    )
    FROM Transactions t1
    WHERE t1.userid = 1
    AND t1.fullTimestamp <= t.fullTimestamp
  ) AS running_balance
FROM Transactions t
WHERE t.userid = 1
AND t.status = 'successful'
ORDER BY t.fullTimestamp ASC;

```

In areas where we have userId we replace it with the specific user id, (in my case, I've created dummy data and have just one user with userId=1) that we want to retrieve the transaction history. A breakdown of how the operation works:

**Filtering:**

- `WHERE t.userId = USER_ID`: This clause ensures you only get transactions associated with a specific user identified by `USER_ID`.
- `WHERE t.status = 'successful'`: This filters out any pending or failed transactions, focusing on completed ones.

**Data Retrieval:**

- `t.transactionId`, `t.transactionType`, `t.fullTimestamp`: These directly retrieve basic transaction details.
- `senderAmount`, `receiverAmount`, `senderCurrency`, `receiverCurrency`: These capture the transaction amounts and currencies involved.
- `CASE` statement: This calculates the amount received in the user's base currency, considering different transaction types:
  - Deposits and withdrawals: Use the `senderAmount` as it represents the received amount.
  - Transfers where the user is the receiver: Use the `receiverAmount` as it represents what was received.
  - Other transfers: We can ignore the amount since it doesn't impact the user's balance.
- `running_balance` subquery: This calculates the user's running balance at the time of each transaction by summing up all previous successful transactions for that user.

**Ordering:**

- `ORDER BY t.fullTimestamp ASC`: This sorts the results chronologically, starting with the earliest transactions.

**Caveats**

- In the currency conversions table we only have one single currency that is USD

### 2. Audit of incoming funds through transfer transactions can be done as follows:

```sql
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
```

A breakdown of how this works is as follows:- It employs recursive common table expression (CTE) which can trace the chain of transfer transactions for each received transfer allowing us to hop from the received transfer to the original sender.

- `transfer_chain` starts with user's received transfer and iteratively joins with `Transactions` table using `senderId` to trace the chain backwards.
- The outer join joins `Transactions` with `transfer_chain` on `transactionId` to access data from both.
