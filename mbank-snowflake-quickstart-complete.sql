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

-- Uzywanie bazy danych
USE DATABASE MBANK_DEMO;

-- Tworzenie schematu
CREATE SCHEMA QUICKSTART_SCHEMA;

-- Uzywanie schematu
USE SCHEMA QUICKSTART_SCHEMA;

-- Sprawdzenie dostepnych baz danych
SHOW DATABASES;

-- Sprawdzenie schematow
SHOW SCHEMAS;

-- ===============================================
-- 2. TABLES
-- ===============================================

-- Podstawowa tabela
CREATE TABLE MBANK_CUSTOMERS (
    CUSTOMER_ID NUMBER(10,0) PRIMARY KEY,
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
(1, 'Jan', 'Kowalski', 'jan.kowalski@mbank.pl', '+48123456789'),
(2, 'Anna', 'Nowak', 'anna.nowak@mbank.pl', '+48987654321'),
(3, 'Piotr', 'Wiśniewski', 'piotr.wisniewski@mbank.pl', '+48555123456'),
(4, 'Maria', 'Wójcik', 'maria.wojcik@mbank.pl', '+48666789012'),
(5, 'Tomasz', 'Kowalczyk', 'tomasz.kowalczyk@mbank.pl', '+48777345678'),
(6, 'Katarzyna', 'Kamińska', 'katarzyna.kaminska@mbank.pl', '+48888901234'),
(7, 'Michał', 'Lewandowski', 'michal.lewandowski@mbank.pl', '+48999567890'),
(8, 'Agnieszka', 'Zielińska', 'agnieszka.zielinska@mbank.pl', '+48111234567'),
(9, 'Paweł', 'Szymański', 'pawel.szymanski@mbank.pl', '+48222890123'),
(10, 'Monika', 'Dąbrowska', 'monika.dabrowska@mbank.pl', '+48333456789');

-- Tworzenie tabeli MBANK_ACCOUNTS
CREATE TABLE MBANK_ACCOUNTS (
    ACCOUNT_ID NUMBER(10,0) PRIMARY KEY,
    CUSTOMER_ID NUMBER(10,0),
    ACCOUNT_TYPE VARCHAR(50),
    BALANCE NUMBER(15,2),
    CREATED_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Wstawianie przykladowych danych do MBANK_ACCOUNTS
INSERT INTO MBANK_ACCOUNTS 
(ACCOUNT_ID, CUSTOMER_ID, ACCOUNT_TYPE, BALANCE)
VALUES 
(1, 1, 'CHECKING', 5000.00),
(2, 1, 'SAVINGS', 15000.00),
(3, 2, 'CHECKING', 2500.00),
(4, 2, 'SAVINGS', 8000.00),
(5, 3, 'CHECKING', 12000.00),
(6, 4, 'SAVINGS', 25000.00),
(7, 5, 'CHECKING', 3500.00),
(8, 6, 'CHECKING', 7500.00),
(9, 7, 'SAVINGS', 45000.00),
(10, 8, 'CHECKING', 1200.00),
(11, 9, 'SAVINGS', 18000.00),
(12, 10, 'CHECKING', 6800.00);

-- Sprawdzenie danych
SELECT COUNT(*) AS customer_count FROM MBANK_CUSTOMERS;
SELECT COUNT(*) AS account_count FROM MBANK_ACCOUNTS;

-- Przeglad danych z joinami
SELECT 
    c.FIRST_NAME || ' ' || c.LAST_NAME AS customer_name,
    a.ACCOUNT_TYPE,
    a.BALANCE
FROM MBANK_CUSTOMERS c
JOIN MBANK_ACCOUNTS a ON c.CUSTOMER_ID = a.CUSTOMER_ID
ORDER BY c.CUSTOMER_ID, a.ACCOUNT_TYPE;

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

-- Przyznawanie uprawnien do tabeli MBANK_CUSTOMERS
GRANT SELECT ON TABLE MBANK_CUSTOMERS TO ROLE PUBLIC;

-- Sprawdzanie uprawnien do tabeli MBANK_CUSTOMERS
SHOW GRANTS ON TABLE MBANK_CUSTOMERS;

-- Przyznawanie uprawnien do tabeli MBANK_ACCOUNTS
GRANT SELECT ON TABLE MBANK_ACCOUNTS TO ROLE PUBLIC;

-- ===============================================
-- 4. CONSTRAINTS
-- ===============================================

-- Snowflake obsluguje tylko: PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL
-- UWAGA: Dla standardowych tabel constraints nie sa egzekwowane oprocz NOT NULL

-- Tabela z PRIMARY KEY constraint
CREATE TABLE MBANK_PRODUCTS (
    PRODUCT_ID NUMBER(10,0) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRODUCT_TYPE VARCHAR(50),
    PRICE NUMBER(10,2)
);

-- Dodanie FOREIGN KEY constraint
ALTER TABLE MBANK_ACCOUNTS 
ADD CONSTRAINT FK_CUSTOMER 
FOREIGN KEY (CUSTOMER_ID) 
REFERENCES MBANK_CUSTOMERS(CUSTOMER_ID);

-- Dodanie UNIQUE constraint
ALTER TABLE MBANK_CUSTOMERS 
ADD CONSTRAINT UK_EMAIL UNIQUE (EMAIL);

-- NOT NULL constraint
ALTER TABLE MBANK_CUSTOMERS 
ALTER COLUMN EMAIL SET NOT NULL;

-- Sprawdzanie informacji o constraints
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    CONSTRAINT_TYPE,
    ENFORCED
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'QUICKSTART_SCHEMA';

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

-- Testowanie widoku
SELECT * FROM CUSTOMER_SUMMARY 
WHERE TOTAL_BALANCE > 10000 
ORDER BY TOTAL_BALANCE DESC;

-- Bezpieczny widok ukrywa definicje
CREATE SECURE VIEW SENSITIVE_CUSTOMER_DATA AS
SELECT 
    CUSTOMER_ID,
    FIRST_NAME,
    SUBSTR(EMAIL, 1, 3) || '***' AS MASKED_EMAIL
FROM MBANK_CUSTOMERS;

-- Sprawdzenie definicji widoku bedzie ukryta
DESCRIBE VIEW SENSITIVE_CUSTOMER_DATA;

-- Proba podgladu definicji bedzie zabroniona
SELECT GET_DDL('VIEW', 'SENSITIVE_CUSTOMER_DATA');
-- Blad: Access to DDL for secure view SENSITIVE_CUSTOMER_DATA is restricted

-- Porownanie z zwyklym widokiem to dziala
SELECT GET_DDL('VIEW', 'CUSTOMER_SUMMARY');

-- Sprawdzenie typu widoku
SHOW VIEWS LIKE '%CUSTOMER%';
-- Kolumna is_secure pokaze true dla secure view

-- Testowanie secure view
SELECT * FROM SENSITIVE_CUSTOMER_DATA 
ORDER BY CUSTOMER_ID;

-- Zmaterializowany widok dla wydajnosci
CREATE MATERIALIZED VIEW DAILY_ACCOUNT_SUMMARY AS
SELECT 
    DATE_TRUNC('DAY', CREATED_DATE) AS ACCOUNT_DATE,
    ACCOUNT_TYPE,
    COUNT(*) AS ACCOUNT_COUNT,
    AVG(BALANCE) AS AVG_BALANCE
FROM MBANK_ACCOUNTS
GROUP BY DATE_TRUNC('DAY', CREATED_DATE), ACCOUNT_TYPE;

-- Testowanie materialized view
SELECT 
    ACCOUNT_DATE,
    ACCOUNT_TYPE,
    ACCOUNT_COUNT,
    ROUND(AVG_BALANCE, 2) AS AVG_BALANCE
FROM DAILY_ACCOUNT_SUMMARY 
ORDER BY ACCOUNT_DATE, ACCOUNT_TYPE;

-- ===============================================
-- 6. RESULT_SCAN FUNCTION
-- ===============================================

-- Pierwsze zapytanie
SELECT CUSTOMER_ID, TOTAL_BALANCE 
FROM CUSTOMER_SUMMARY 
WHERE TOTAL_BALANCE > 10000;

-- Wykorzystanie wynikow poprzedniego zapytania
SELECT AVG(TOTAL_BALANCE) AS AVG_HIGH_BALANCE
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- Zapytanie z identyfikatorem
SELECT QUERY_ID, QUERY_TEXT 
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY()) 
WHERE QUERY_TEXT ILIKE '%MBANK_CUSTOMERS%' 
LIMIT 5;

-- Przyklad uzycia konkretnego ID zapytania zastap swoim ID
-- SELECT * FROM TABLE(RESULT_SCAN('01234567-89ab-cdef-ghij-klmnopqrstuv'));

-- ===============================================
-- 7. SYSTEM FUNCTIONS
-- ===============================================

-- Aktualna wersja Snowflake
SELECT CURRENT_VERSION();

-- Aktualny uzytkownik i rola
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

-- Konwersje typow
SELECT 
    TO_NUMBER('123.45') AS NUM_VALUE,
    TO_DATE('2024-01-15', 'YYYY-MM-DD') AS DATE_VALUE,
    TO_VARCHAR(CURRENT_DATE(), 'YYYY-MM-DD') AS STRING_DATE;

-- ===============================================
-- 8. EXTERNAL TABLES
-- ===============================================

-- UWAGA: Ponizsze przyklady wymagaja konfiguracji Azure credentials
-- Dostosuj URL i credentials do swojego srodowiska Azure

-- Opcja 1: Uzywanie SAS Token mniej bezpieczne
-- CREATE OR REPLACE STAGE MBANK_EXTERNAL_STAGE
-- URL = 'azure://mbankstorageacct.blob.core.windows.net/customer-data/'
-- CREDENTIALS = (AZURE_SAS_TOKEN = 'your-sas-token');

-- Opcja 2: Uzywanie Storage Integration rekomendowane
-- Najpierw stworz Storage Integration:
-- CREATE STORAGE INTEGRATION AZURE_INTEGRATION
--   TYPE = EXTERNAL_STAGE
--   STORAGE_PROVIDER = AZURE
--   ENABLED = TRUE
--   AZURE_TENANT_ID = 'your-tenant-id'
--   STORAGE_ALLOWED_LOCATIONS = 'azure://mbankstorageacct.blob.core.windows.net/customer-data/';

-- CREATE OR REPLACE STAGE MBANK_EXTERNAL_STAGE
-- URL = 'azure://mbankstorageacct.blob.core.windows.net/customer-data/'
-- STORAGE_INTEGRATION = AZURE_INTEGRATION;

-- External table dla plikow CSV z Azure
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

-- Sprawdzenie metadanych plikow Azure
-- SELECT 
--     FILE_NAME,
--     FILE_SIZE,
--     LAST_MODIFIED
-- FROM TABLE(INFORMATION_SCHEMA.EXTERNAL_TABLE_FILES(
--     TABLE_NAME => 'MBANK_EXTERNAL_CUSTOMERS'
-- ));

-- Odswiezenie metadanych
-- ALTER EXTERNAL TABLE MBANK_EXTERNAL_CUSTOMERS REFRESH;

-- ===============================================
-- 9. DYNAMIC TABLES - WPROWADZENIE
-- ===============================================

-- Dynamic table - agregacja danych kont
CREATE OR REPLACE DYNAMIC TABLE MBANK_ACCOUNT_SUMMARY
TARGET_LAG = '1 minute'
WAREHOUSE = COMPUTE_WH
AS
SELECT 
    ACCOUNT_TYPE,
    COUNT(*) AS ACCOUNT_COUNT,
    SUM(BALANCE) AS TOTAL_BALANCE,
    AVG(BALANCE) AS AVG_BALANCE,
    MAX(BALANCE) AS MAX_BALANCE,
    MIN(BALANCE) AS MIN_BALANCE
FROM MBANK_ACCOUNTS
GROUP BY ACCOUNT_TYPE;

-- Sprawdzenie zawartosci Dynamic Table
SELECT * FROM MBANK_ACCOUNT_SUMMARY ORDER BY ACCOUNT_TYPE;

-- ===============================================
-- 10. DYNAMIC TABLES - TESTOWANIE
-- ===============================================

-- Sprawdzenie aktualnego stanu Dynamic Table
SELECT * FROM MBANK_ACCOUNT_SUMMARY ORDER BY ACCOUNT_TYPE;

-- Dodanie nowego klienta
INSERT INTO MBANK_CUSTOMERS 
(CUSTOMER_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER)
VALUES 
(11, 'Adam', 'Kowalski', 'adam.kowalski@mbank.pl', '+48444555666');

-- Dodanie kont dla nowego klienta
INSERT INTO MBANK_ACCOUNTS 
(ACCOUNT_ID, CUSTOMER_ID, ACCOUNT_TYPE, BALANCE)
VALUES 
(13, 11, 'CHECKING', 15000.00),
(14, 11, 'SAVINGS', 50000.00);

-- Modyfikacja salda istniejacego konta
UPDATE MBANK_ACCOUNTS 
SET BALANCE = 75000.00 
WHERE ACCOUNT_ID = 1;

-- Sprawdzenie zmian w Dynamic Table po około minucie
-- Dynamic Table odswiezana zgodnie z TARGET_LAG 1 minute
SELECT * FROM MBANK_ACCOUNT_SUMMARY ORDER BY ACCOUNT_TYPE;

-- Usuniecie testowych danych
DELETE FROM MBANK_ACCOUNTS WHERE CUSTOMER_ID = 11;
DELETE FROM MBANK_CUSTOMERS WHERE CUSTOMER_ID = 11;

-- Cofniecie zmiany salda
UPDATE MBANK_ACCOUNTS 
SET BALANCE = 5000.00 
WHERE ACCOUNT_ID = 1;

-- Ponowne sprawdzenie Dynamic Table po usunieciu
SELECT * FROM MBANK_ACCOUNT_SUMMARY ORDER BY ACCOUNT_TYPE;

-- OPCJONALNIE: Wymuszenie odswiezenia Dynamic Table zamiast czekania na TARGET_LAG
-- ALTER DYNAMIC TABLE MBANK_ACCOUNT_SUMMARY REFRESH;

-- Sprawdzenie czasu ostatniego odswiezenia
SELECT 
    NAME,
    LATEST_DATA_TIMESTAMP,
    DATEDIFF('minute', LATEST_DATA_TIMESTAMP, CURRENT_TIMESTAMP()) AS MINUTES_SINCE_REFRESH
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLES())
WHERE NAME = 'MBANK_ACCOUNT_SUMMARY';

-- ===============================================
-- 11. DYNAMIC TABLE - MONITOROWANIE
-- ===============================================

-- Status wszystkich dynamic tables
SHOW DYNAMIC TABLES;

-- Szczegolowe informacje
SELECT 
    NAME,
    DATABASE_NAME,
    SCHEMA_NAME,
    TARGET_LAG_SEC,
    WAREHOUSE,
    REFRESH_MODE,
    LATEST_DATA_TIMESTAMP
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLES());

-- Historia odswiezania Dynamic Table
SELECT 
    NAME,
    REFRESH_START_TIME,
    REFRESH_END_TIME,
    REFRESH_TRIGGER,
    STATE,
    STATE_MESSAGE
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY(
    NAME => 'MBANK_ACCOUNT_SUMMARY'
))
ORDER BY REFRESH_START_TIME DESC;

-- Analiza kosztow i wydajnosci
SELECT 
    DATE_TRUNC('day', REFRESH_START_TIME) AS REFRESH_DATE,
    COUNT(*) AS REFRESH_COUNT,
    AVG(DATEDIFF('second', REFRESH_START_TIME, REFRESH_END_TIME)) AS AVG_DURATION_SEC,
    COUNT(CASE WHEN STATE = 'SUCCEEDED' THEN 1 END) AS SUCCESSFUL_REFRESHES
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY(
    NAME => 'MBANK_ACCOUNT_SUMMARY'
))
WHERE REFRESH_START_TIME >= DATEADD('day', -7, CURRENT_TIMESTAMP())
GROUP BY DATE_TRUNC('day', REFRESH_START_TIME)
ORDER BY REFRESH_DATE;

-- Sprawdzenie opoznien w odswiezaniu
SELECT 
    NAME,
    TARGET_LAG_SEC,
    DATEDIFF('minute', LATEST_DATA_TIMESTAMP, CURRENT_TIMESTAMP()) AS ACTUAL_LAG_MINUTES
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLES())
WHERE DATEDIFF('minute', LATEST_DATA_TIMESTAMP, CURRENT_TIMESTAMP()) > 
      (TARGET_LAG_SEC / 60) * 2;

-- ===============================================
-- KONIEC SKRYPTU
-- ===============================================
-- Gratulacje! Wykonales wszystkie polecenia z mBank Snowflake Quickstart
-- Pamietaj o czyszczeniu zasobow po zakonczeniu cwiczen:
-- DROP DYNAMIC TABLE MBANK_ACCOUNT_SUMMARY;
-- DROP MATERIALIZED VIEW DAILY_ACCOUNT_SUMMARY;
-- DROP VIEW CUSTOMER_SUMMARY;
-- DROP SECURE VIEW SENSITIVE_CUSTOMER_DATA;
-- DROP TABLE MBANK_PRODUCTS;
-- DROP TABLE MBANK_ACCOUNTS;
-- DROP TABLE MBANK_CUSTOMERS;
-- DROP SCHEMA QUICKSTART_SCHEMA;
-- DROP DATABASE MBANK_DEMO; 