INSERT INTO user_audit_trail.users (userid, balance, currency) VALUES (1, 1000.00, 'USD');
INSERT INTO user_audit_trail.transactions (transactionid, transactiontype, userid, fulltimestamp, status, senderamount, receiveramount, sendercurrency, receivercurrency, senderid, receiverid)
VALUES (1, 'deposit', 1, '2024-02-23 12:00:00', 'successful', 500.00, 500.00, 'USD', 'USD', 1, 1);
INSERT INTO user_audit_trail.transactions (transactionid, transactiontype, userid, fulltimestamp, status, senderamount, receiveramount, sendercurrency, receivercurrency, senderid, receiverid)
VALUES
  (2, 'deposit', 1, '2024-02-24 12:00:00', 'successful', 300.00, 300.00, 'USD', 'USD', 1, 1),
  (3, 'withdrawal', 1, '2024-02-25 12:00:00', 'successful', 200.00, 200.00, 'USD', 'USD', 1, 1);


