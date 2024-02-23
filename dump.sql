--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
-- Dumped by pg_dump version 16.2 (Debian 16.2-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: currencyconversions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currencyconversions (
    fromcurrency character varying(3),
    tocurrency character varying(3),
    conversionrate numeric(10,6)
);


ALTER TABLE public.currencyconversions OWNER TO postgres;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
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


ALTER TABLE public.transactions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    userid integer NOT NULL,
    balance numeric(10,2),
    currency character varying(3)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: currencyconversions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currencyconversions (fromcurrency, tocurrency, conversionrate) FROM stdin;
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transactionid, transactiontype, userid, fulltimestamp, status, senderamount, receiveramount, sendercurrency, receivercurrency, senderid, receiverid) FROM stdin;
1	deposit	1	2024-02-23 12:00:00	successful	500.00	500.00	USD	USD	1	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (userid, balance, currency) FROM stdin;
1	1000.00	USD
\.


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transactionid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- Name: transactions transactions_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid);


--
-- PostgreSQL database dump complete
--

