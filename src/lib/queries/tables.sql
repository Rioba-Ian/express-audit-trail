CREATE SCHEMA IF NOT EXISTS user_audit_trail;
SET search_path = user_audit_trail;
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;


CREATE TABLE user_audit_trail.currencyconversions (
    fromcurrency character varying(3),
    tocurrency character varying(3),
    conversionrate numeric(10,6)
);


ALTER TABLE user_audit_trail.currencyconversions OWNER TO postgres;


CREATE TABLE user_audit_trail.transactions (
    transactionid integer NOT NULL,
    transactiontype character varying(10),
    userid integer,
    fulltimestamp timestamp without time zone,
    status character varying(10),
    senderamount numeric(10,2),
    receiveramount numeric(10,2),
    sendercurrency character varying(3),
    receivercurrency character varying(3),
    senderid integer,
    receiverid integer
);


ALTER TABLE user_audit_trail.transactions OWNER TO postgres;

CREATE TABLE user_audit_trail.users (
    userid integer NOT NULL,
    balance numeric(10,2),
    currency character varying(3)
);


ALTER TABLE user_audit_trail.users OWNER TO postgres;

ALTER TABLE ONLY user_audit_trail.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transactionid);

ALTER TABLE ONLY user_audit_trail.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);

ALTER TABLE ONLY user_audit_trail.transactions
    ADD CONSTRAINT transactions_userid_fkey FOREIGN KEY (userid) REFERENCES user_audit_trail.users(userid);
