-- ===============================================
-- mBank Snowflake Quickstart - Complete SQL Script
-- ===============================================
-- Ten plik zawiera wszystkie polecenia SQL z quickstartu
-- Wykonuj sekcje kolejno zgodnie z instrukcjami

-- ===============================================
-- 1. DATABASE OBJECTS AND COMMANDS
-- ===============================================

-- Tworzenie bazy danych
CREATE DATABASE MBANK_DEMO;

-- Używanie bazy danych
USE DATABASE MBANK_DEMO;

-- Tworzenie schematu
CREATE SCHEMA QUICKSTART_SCHEMA;

-- Używanie schematu
USE SCHEMA QUICKSTART_SCHEMA;

-- Sprawdzenie dostępnych baz danych
SHOW DATABASES;

-- Sprawdzenie schematów
SHOW SCHEMAS;

-- ===============================================
-- 2. TABLES
-- ===============================================

-- Podstawowa tabela
CREATE TABLE MBANK_CUSTOMERS (
    CUSTOMER_ID NUMBER(10,0),
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50), 
    EMAIL VARCHAR(100),
    PHONE_NUMBER VARCHAR(20),
    CREATED_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Wstawianie danych
INSERT INTO MBANK_CUSTOMERS 
(CUSTOMER_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER)
VALUES 
(1, 'Jan', 'Kowalski', 'jan.kowalski@example.com', '+48123456789'),
(2, 'Anna', 'Nowak', 'anna.nowak@example.com', '+48987654321');

-- Ćwiczenie - tabela MBANK_ACCOUNTS
CREATE TABLE MBANK_ACCOUNTS (
    ACCOUNT_ID NUMBER(10,0),
    CUSTOMER_ID NUMBER(10,0),
    ACCOUNT_TYPE VARCHAR(50),
    BALANCE NUMBER(15,2),
    CREATED_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Przykładowe dane dla MBANK_ACCOUNTS
INSERT INTO MBANK_ACCOUNTS 
(ACCOUNT_ID, CUSTOMER_ID, ACCOUNT_TYPE, BALANCE)
VALUES 
(1, 1, 'CHECKING', 5000.00),
(2, 1, 'SAVINGS', 15000.00),
(3, 2, 'CHECKING', 2500.00);

-- ===============================================
-- 3. OBJECTS
-- ===============================================

-- Opis tabeli MBANK_CUSTOMERS
DESCRIBE TABLE MBANK_CUSTOMERS;

-- Lista wszystkich tabel
SHOW TABLES;

-- Informacje o kolumnach w tabeli MBANK_CUSTOMERS
SHOW COLUMNS IN TABLE MBANK_CUSTOMERS;

-- Informacje o tabeli MBANK_ACCOUNTS
DESCRIBE TABLE MBANK_ACCOUNTS;

-- Przyznawanie uprawnień do tabeli MBANK_CUSTOMERS
GRANT SELECT ON TABLE MBANK_CUSTOMERS TO ROLE PUBLIC;

-- Sprawdzanie uprawnień do tabeli MBANK_CUSTOMERS
SHOW GRANTS ON TABLE MBANK_CUSTOMERS;

-- Przyznawanie uprawnień do tabeli MBANK_ACCOUNTS
GRANT SELECT ON TABLE MBANK_ACCOUNTS TO ROLE PUBLIC;

-- ===============================================
-- 4. CONSTRAINTS
-- ===============================================

-- Tabela z ograniczeniami
CREATE TABLE MBANK_PRODUCTS (
    PRODUCT_ID NUMBER(10,0) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRODUCT_TYPE VARCHAR(50),
    PRICE NUMBER(10,2)
);

-- Dodanie CHECK constraint dla ceny
ALTER TABLE MBANK_PRODUCTS 
ADD CONSTRAINT CHK_PRICE_POSITIVE 
CHECK (PRICE > 0);

-- Dodanie klucza obcego
ALTER TABLE MBANK_ACCOUNTS 
ADD CONSTRAINT FK_CUSTOMER 
FOREIGN KEY (CUSTOMER_ID) 
REFERENCES MBANK_CUSTOMERS(CUSTOMER_ID);

-- Sprawdzenie wartości
ALTER TABLE MBANK_ACCOUNTS 
ADD CONSTRAINT CHK_BALANCE 
CHECK (BALANCE >= 0);

-- Kolumna nie może być pusta
ALTER TABLE MBANK_CUSTOMERS 
ALTER COLUMN EMAIL SET NOT NULL;

-- ===============================================
-- 5. VIEWS
-- ===============================================

-- Podstawowy widok
CREATE VIEW CUSTOMER_SUMMARY AS
SELECT 
    c.CUSTOMER_ID,
    c.FIRST_NAME || ' ' || c.LAST_NAME AS FULL_NAME,
    c.EMAIL,
    COUNT(a.ACCOUNT_ID) AS ACCOUNT_COUNT,
    SUM(a.BALANCE) AS TOTAL_BALANCE
FROM MBANK_CUSTOMERS c
LEFT JOIN MBANK_ACCOUNTS a ON c.CUSTOMER_ID = a.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID, c.FIRST_NAME, c.LAST_NAME, c.EMAIL;

-- Bezpieczny widok (ukrywa definicję)
CREATE SECURE VIEW SENSITIVE_CUSTOMER_DATA AS
SELECT 
    CUSTOMER_ID,
    FIRST_NAME,
    SUBSTR(EMAIL, 1, 3) || '***' AS MASKED_EMAIL
FROM MBANK_CUSTOMERS;

-- Zmaterializowany widok dla wydajności
CREATE MATERIALIZED VIEW DAILY_ACCOUNT_SUMMARY AS
SELECT 
    DATE_TRUNC('DAY', CREATED_DATE) AS ACCOUNT_DATE,
    ACCOUNT_TYPE,
    COUNT(*) AS ACCOUNT_COUNT,
    AVG(BALANCE) AS AVG_BALANCE
FROM MBANK_ACCOUNTS
GROUP BY DATE_TRUNC('DAY', CREATED_DATE), ACCOUNT_TYPE;

-- ===============================================
-- 6. RESULT_SCAN FUNCTION
-- ===============================================

-- Pierwsze zapytanie
SELECT CUSTOMER_ID, TOTAL_BALANCE 
FROM CUSTOMER_SUMMARY 
WHERE TOTAL_BALANCE > 10000;

-- Wykorzystanie wyników poprzedniego zapytania
SELECT AVG(TOTAL_BALANCE) AS AVG_HIGH_BALANCE
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- Zapytanie z identyfikatorem
SELECT QUERY_ID, QUERY_TEXT 
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY()) 
WHERE QUERY_TEXT ILIKE '%MBANK_CUSTOMERS%' 
LIMIT 5;

-- Przykład użycia konkretnego ID zapytania (zastąp swoim ID)
-- SELECT * FROM TABLE(RESULT_SCAN('01234567-89ab-cdef-ghij-klmnopqrstuv'));

-- ===============================================
-- 7. SYSTEM FUNCTIONS
-- ===============================================

-- Aktualna wersja Snowflake
SELECT CURRENT_VERSION();

-- Aktualny użytkownik i rola
SELECT CURRENT_USER(), CURRENT_ROLE();

-- Aktualny warehouse i baza danych
SELECT CURRENT_WAREHOUSE(), CURRENT_DATABASE();

-- Aktualna data i czas
SELECT 
    CURRENT_TIMESTAMP() AS CURRENT_TS,
    CURRENT_DATE() AS CURRENT_DATE,
    CURRENT_TIME() AS CURRENT_TIME;

-- Operacje na datach
SELECT 
    DATEADD('day', 30, CURRENT_DATE()) AS FUTURE_DATE,
    DATEDIFF('day', '2024-01-01', CURRENT_DATE()) AS DAYS_SINCE_NY;

-- Konwersje typów
SELECT 
    TO_NUMBER('123.45') AS NUM_VALUE,
    TO_DATE('2024-01-15', 'YYYY-MM-DD') AS DATE_VALUE,
    TO_VARCHAR(CURRENT_DATE(), 'YYYY-MM-DD') AS STRING_DATE;

-- ===============================================
-- 8. EXTERNAL TABLES
-- ===============================================

-- UWAGA: Poniższe przykłady wymagają konfiguracji AWS credentials
-- Dostosuj URL i credentials do swojego środowiska

-- Tworzenie stage dla zewnętrznych danych
-- CREATE OR REPLACE STAGE MBANK_EXTERNAL_STAGE
-- URL = 's3://mbank-data-bucket/customer-data/'
-- CREDENTIALS = (AWS_KEY_ID = 'your-key' AWS_SECRET_KEY = 'your-secret');

-- External table dla plików CSV
-- CREATE OR REPLACE EXTERNAL TABLE MBANK_EXTERNAL_CUSTOMERS (
--     CUSTOMER_ID NUMBER AS (VALUE:c1::NUMBER),
--     FIRST_NAME VARCHAR AS (VALUE:c2::VARCHAR),
--     LAST_NAME VARCHAR AS (VALUE:c3::VARCHAR),
--     EMAIL VARCHAR AS (VALUE:c4::VARCHAR)
-- )
-- LOCATION = @MBANK_EXTERNAL_STAGE
-- FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);

-- Podstawowe zapytanie do external table
-- SELECT * FROM MBANK_EXTERNAL_CUSTOMERS LIMIT 10;

-- Filtrowanie external table
-- SELECT FIRST_NAME, LAST_NAME 
-- FROM MBANK_EXTERNAL_CUSTOMERS 
-- WHERE EMAIL LIKE '%@mbank.pl';

-- Odświeżenie metadanych
-- ALTER EXTERNAL TABLE MBANK_EXTERNAL_CUSTOMERS REFRESH;

-- ===============================================
-- 9. DYNAMIC TABLES
-- ===============================================

-- Dynamic table z automatycznym odświeżaniem
CREATE OR REPLACE DYNAMIC TABLE MBANK_CUSTOMER_METRICS
TARGET_LAG = '1 hour'
WAREHOUSE = COMPUTE_WH
AS
SELECT 
    DATE_TRUNC('hour', CREATED_DATE) AS HOUR_PERIOD,
    COUNT(*) AS NEW_CUSTOMERS,
    COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTOMERS
FROM MBANK_CUSTOMERS
GROUP BY DATE_TRUNC('hour', CREATED_DATE);

-- Dynamic table z różnymi opcjami LAG
CREATE OR REPLACE DYNAMIC TABLE MBANK_ACCOUNT_SUMMARY
TARGET_LAG = '15 minutes'
WAREHOUSE = COMPUTE_WH
AS
SELECT 
    ACCOUNT_TYPE,
    COUNT(*) AS ACCOUNT_COUNT,
    SUM(BALANCE) AS TOTAL_BALANCE,
    AVG(BALANCE) AS AVG_BALANCE,
    MAX(BALANCE) AS MAX_BALANCE
FROM MBANK_ACCOUNTS
GROUP BY ACCOUNT_TYPE;

-- Dynamic table z join'ami
CREATE OR REPLACE DYNAMIC TABLE MBANK_CUSTOMER_ACCOUNT_VIEW
TARGET_LAG = '30 minutes'
WAREHOUSE = COMPUTE_WH
AS
SELECT 
    c.CUSTOMER_ID,
    c.FIRST_NAME || ' ' || c.LAST_NAME AS FULL_NAME,
    a.ACCOUNT_TYPE,
    a.BALANCE,
    CASE 
        WHEN a.BALANCE >= 100000 THEN 'VIP'
        WHEN a.BALANCE >= 50000 THEN 'PREMIUM'
        ELSE 'STANDARD'
    END AS CUSTOMER_TIER
FROM MBANK_CUSTOMERS c
JOIN MBANK_ACCOUNTS a ON c.CUSTOMER_ID = a.CUSTOMER_ID;

-- ===============================================
-- 10. MONITORING DYNAMIC TABLES
-- ===============================================

-- Status wszystkich dynamic tables
SHOW DYNAMIC TABLES;

-- Szczegółowe informacje
SELECT 
    NAME,
    DATABASE_NAME,
    SCHEMA_NAME,
    TARGET_LAG,
    WAREHOUSE,
    REFRESH_MODE,
    LAST_DATA_TIMESTAMP
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLES());

-- Historia odświeżania Dynamic Table
SELECT 
    TABLE_NAME,
    REFRESH_START_TIME,
    REFRESH_END_TIME,
    REFRESH_TRIGGER,
    BYTES_PROCESSED,
    ROWS_PRODUCED
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY(
    'MBANK_CUSTOMER_METRICS'
))
ORDER BY REFRESH_START_TIME DESC;

-- Analiza kosztów i wydajności
SELECT 
    DATE_TRUNC('day', REFRESH_START_TIME) AS REFRESH_DATE,
    COUNT(*) AS REFRESH_COUNT,
    SUM(BYTES_PROCESSED) AS TOTAL_BYTES,
    AVG(DATEDIFF('second', REFRESH_START_TIME, REFRESH_END_TIME)) AS AVG_DURATION_SEC
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY(
    'MBANK_CUSTOMER_METRICS'
))
WHERE REFRESH_START_TIME >= DATEADD('day', -7, CURRENT_TIMESTAMP())
GROUP BY DATE_TRUNC('day', REFRESH_START_TIME)
ORDER BY REFRESH_DATE;

-- Sprawdzenie opóźnień w odświeżaniu
SELECT 
    NAME,
    TARGET_LAG,
    DATEDIFF('minute', LAST_DATA_TIMESTAMP, CURRENT_TIMESTAMP()) AS ACTUAL_LAG_MINUTES
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLES())
WHERE DATEDIFF('minute', LAST_DATA_TIMESTAMP, CURRENT_TIMESTAMP()) > 
      EXTRACT(MINUTE FROM TARGET_LAG) * 2;

-- ===============================================
-- KONIEC SKRYPTU
-- ===============================================
-- Gratulacje! Wykonałeś wszystkie polecenia z mBank Snowflake Quickstart
-- Pamiętaj o czyszczeniu zasobów po zakończeniu ćwiczeń:
-- DROP DYNAMIC TABLE MBANK_CUSTOMER_METRICS;
-- DROP DYNAMIC TABLE MBANK_ACCOUNT_SUMMARY;
-- DROP DYNAMIC TABLE MBANK_CUSTOMER_ACCOUNT_VIEW;
-- DROP MATERIALIZED VIEW DAILY_ACCOUNT_SUMMARY;
-- DROP VIEW CUSTOMER_SUMMARY;
-- DROP SECURE VIEW SENSITIVE_CUSTOMER_DATA;
-- DROP TABLE MBANK_PRODUCTS;
-- DROP TABLE MBANK_ACCOUNTS;
-- DROP TABLE MBANK_CUSTOMERS;
-- DROP SCHEMA QUICKSTART_SCHEMA;
-- DROP DATABASE MBANK_DEMO; 