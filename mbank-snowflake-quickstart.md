author: Pablo Mano
summary: Snowflake Database Quickstart Guide
id: snowflake-quickstart
categories: snowflake,database,sql
environments: web
status: Published
feedback link: https://github.com/sfc-gh-pmanowiecki/getstarted

# Snowflake Database Quickstart v1.2

## Wprowadzenie
Duration: 5

### Czego się teraz nauczysz?

W tym quickstarcie nauczysz się podstawowych konceptów i operacji w Snowflake, które są kluczowe dla pracy z bazami danych w środowisku mBank.

**Tematy, które omówimy:**
- Database Objects and Commands
- Objects and Tables
- Constraints and Views  
- System Functions
- External and Dynamic Tables
- Monitoring i optymalizacja

### Prerequisites

- Dostęp do Snowflake - możesz założyć darmowe konto [https://trial.snowflake.com](https://trial.snowflake.com)
- Podstawowa znajomość SQL
- Uprawnienia do tworzenia obiektów w bazie danych

### 📥 Kompletny skrypt SQL

Wszystkie polecenia SQL z tego quickstartu są dostępne w jednym pliku:
**[📁 mbank-snowflake-quickstart-complete.sql](https://raw.githubusercontent.com/sfc-gh-pmanowiecki/getstarted/refs/heads/main/mbank-snowflake-quickstart-complete.sql)**

Możesz pobrać ten plik i wykonywać polecenia sekcja po sekcji, lub skopiować i wkleić poszczególne fragmenty do swojego środowiska Snowflake.

## Obiekty bazodanowe
Duration: 8

### Przegląd obiektów bazodanowych

W Snowflake główne obiekty bazodanowe to:

- **Databases** - kontener najwyższego poziomu
- **Schemas** - logiczne grupowanie obiektów
- **Tables** - struktura przechowywania danych
- **Views** - wirtualne tabele
- **Functions** - programowalne obiekty

### Podstawowe komendy

```sql
-- Tworzenie bazy danych
CREATE DATABASE MBANK_DEMO;

-- Uzywanie bazy danych
USE DATABASE MBANK_DEMO;

-- Tworzenie schematu
CREATE SCHEMA QUICKSTART_SCHEMA;

-- Uzywanie schematu
USE SCHEMA QUICKSTART_SCHEMA;
```

### Ćwiczenie praktyczne

Wykonaj poniższe komendy w swojej sesji Snowflake:

```sql
-- Sprawdzenie dostepnych baz danych
SHOW DATABASES;

-- Sprawdzenie schematow
SHOW SCHEMAS;
```

### 📚 Dodatkowe zasoby

- [Database Objects Overview](https://docs.snowflake.com/en/sql-reference/ddl-database)
- [Schema Management](https://docs.snowflake.com/en/sql-reference/ddl-schema)
- [SQL Commands Reference](https://docs.snowflake.com/en/sql-reference/sql-all)

## Tables  
Duration: 15

### Tworzenie tabel

```sql
-- Podstawowa tabela
CREATE TABLE MBANK_CUSTOMERS (
    CUSTOMER_ID NUMBER(10,0) PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50), 
    EMAIL VARCHAR(100),
    PHONE_NUMBER VARCHAR(20),
    CREATED_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);
```

### Przykładowe typy danych w Snowflake

- **NUMBER** - liczby całkowite i dziesiętne
- **VARCHAR** - tekst o zmiennej długości  
- **TIMESTAMP_NTZ** - znacznik czasu bez strefy czasowej
- **BOOLEAN** - wartości true/false
- **VARIANT** - dane JSON/semi-strukturalne

### Wstawianie danych

```sql
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
```

### Ćwiczenie - Tabela MBANK_ACCOUNTS

Stwórz tabelę `MBANK_ACCOUNTS` i wypełnij ją danymi:

```sql
-- Tworzenie tabeli MBANK_ACCOUNTS
CREATE TABLE MBANK_ACCOUNTS (
    ACCOUNT_ID NUMBER(10,0) PRIMARY KEY,
    CUSTOMER_ID NUMBER(10,0),
    ACCOUNT_TYPE VARCHAR(50),
    BALANCE NUMBER(15,2),
    CREATED_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Wstawianie przykladowych danych
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
```

### 📚 Dodatkowe zasoby

- [CREATE TABLE](https://docs.snowflake.com/en/sql-reference/sql/create-table)
- [Data Types](https://docs.snowflake.com/en/sql-reference/data-types)
- [INSERT Statement](https://docs.snowflake.com/en/sql-reference/sql/insert)
- [Working with Tables](https://docs.snowflake.com/en/user-guide/tables-intro)

## Objects
Duration: 7

### Zarządzanie obiektami

Snowflake oferuje bogate możliwości zarządzania obiektami bazodanowymi.

### Informacje o obiektach

```sql
-- Opis tabeli MBANK_CUSTOMERS
DESCRIBE TABLE MBANK_CUSTOMERS;

-- Lista wszystkich tabel
SHOW TABLES;

-- Informacje o kolumnach w tabeli MBANK_CUSTOMERS
SHOW COLUMNS IN TABLE MBANK_CUSTOMERS;

-- Informacje o tabeli MBANK_ACCOUNTS jesli zostala stworzona
DESCRIBE TABLE MBANK_ACCOUNTS;
```

### Uprawnienia

```sql
-- Przyznawanie uprawnien do tabeli MBANK_CUSTOMERS
GRANT SELECT ON TABLE MBANK_CUSTOMERS TO ROLE PUBLIC;

-- Sprawdzanie uprawnien do tabeli MBANK_CUSTOMERS
SHOW GRANTS ON TABLE MBANK_CUSTOMERS;

-- Przyznawanie uprawnien do tabeli MBANK_ACCOUNTS
GRANT SELECT ON TABLE MBANK_ACCOUNTS TO ROLE PUBLIC;
```

### 📚 Dodatkowe zasoby

- [DESCRIBE Command](https://docs.snowflake.com/en/sql-reference/sql/desc-table)
- [SHOW Commands](https://docs.snowflake.com/en/sql-reference/sql/show)
- [Access Control](https://docs.snowflake.com/en/user-guide/security-access-control-overview)
- [GRANT Privileges](https://docs.snowflake.com/en/sql-reference/sql/grant-privilege)

## Constraints
Duration: 10

### Obsługiwane typy ograniczeń w Snowflake

Snowflake obsługuje tylko następujące typy ograniczeń zgodnie ze standardem ANSI SQL:

- **PRIMARY KEY** - klucz główny
- **FOREIGN KEY** - klucz obcy  
- **UNIQUE** - unikatowość wartości
- **NOT NULL** - wymagana wartość (nie null)

### Ważne ograniczenia funkcjonalności

**Dla standardowych tabel:**
- Ograniczenia są **zdefiniowane ale NIE egzekwowane** (oprócz NOT NULL)
- Służą głównie do celów dokumentacji i kompatybilności z narzędziami BI
- Zapewnienie integralności danych jest odpowiedzialnością aplikacji

**Dla tabel hybrydowych:**
- Wszystkie ograniczenia są w pełni egzekwowane
- PRIMARY KEY jest wymagany

### Przykłady implementacji

```sql
-- Primary Key - zawsze NOT NULL i UNIQUE
CREATE TABLE MBANK_PRODUCTS (
    PRODUCT_ID NUMBER(10,0) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRODUCT_TYPE VARCHAR(50),
    PRICE NUMBER(10,2)
);

-- Foreign Key
ALTER TABLE MBANK_ACCOUNTS 
ADD CONSTRAINT FK_CUSTOMER 
FOREIGN KEY (CUSTOMER_ID) 
REFERENCES MBANK_CUSTOMERS(CUSTOMER_ID);

-- Unique constraint
ALTER TABLE MBANK_CUSTOMERS 
ADD CONSTRAINT UK_EMAIL UNIQUE (EMAIL);

-- Not Null constraint
ALTER TABLE MBANK_CUSTOMERS 
ALTER COLUMN EMAIL SET NOT NULL;
```

### Sprawdzanie ograniczeń

```sql
-- Informacje o ograniczeniach
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    CONSTRAINT_TYPE,
    ENFORCED
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'QUICKSTART_SCHEMA';
```

### 📚 Dodatkowe zasoby

- [Constraints Overview](https://docs.snowflake.com/en/sql-reference/constraints-overview)
- [CREATE TABLE CONSTRAINT](https://docs.snowflake.com/en/sql-reference/sql/create-table-constraint)
- [Table Constraints Information Schema](https://docs.snowflake.com/en/sql-reference/info-schema/table_constraints)
- [Referential Integrity](https://docs.snowflake.com/en/user-guide/table-considerations#referential-integrity-constraints)

## Views
Duration: 12

### Tworzenie widoków

```sql
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
```

### Secure Views

```sql
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
```

### Materialized Views

```sql
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
```

### 📚 Dodatkowe zasoby

- [CREATE VIEW](https://docs.snowflake.com/en/sql-reference/sql/create-view)
- [Secure Views](https://docs.snowflake.com/en/user-guide/views-secure)
- [Materialized Views](https://docs.snowflake.com/en/user-guide/views-materialized)
- [Working with Views](https://docs.snowflake.com/en/user-guide/views-introduction)

## Używanie funkcji Result_Scan
Duration: 6

### Funkcja RESULT_SCAN

RESULT_SCAN pozwala na wykorzystanie wyników poprzedniego zapytania:

```sql
-- Pierwsze zapytanie
SELECT CUSTOMER_ID, TOTAL_BALANCE 
FROM CUSTOMER_SUMMARY 
WHERE TOTAL_BALANCE > 10000;

-- Wykorzystanie wynikow poprzedniego zapytania
SELECT AVG(TOTAL_BALANCE) AS AVG_HIGH_BALANCE
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
```

### Praktyczne zastosowanie

```sql
-- Zapytanie z identyfikatorem
SELECT QUERY_ID, QUERY_TEXT 
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY()) 
WHERE QUERY_TEXT ILIKE '%MBANK_CUSTOMERS%' 
LIMIT 5;

-- Uzycie konkretnego ID zapytania
SELECT * FROM TABLE(RESULT_SCAN('01234567-89ab-cdef-ghij-klmnopqrstuv'));
```

### 📚 Dodatkowe zasoby

- [RESULT_SCAN Function](https://docs.snowflake.com/en/sql-reference/functions/result_scan)
- [Query History](https://docs.snowflake.com/en/user-guide/ui-history)
- [Information Schema](https://docs.snowflake.com/en/sql-reference/info-schema)

## System Functions
Duration: 6

### Funkcje informacyjne

```sql
-- Aktualna wersja Snowflake
SELECT CURRENT_VERSION();

-- Aktualny uzytkownik i rola
SELECT CURRENT_USER(), CURRENT_ROLE();

-- Aktualny warehouse i baza danych
SELECT CURRENT_WAREHOUSE(), CURRENT_DATABASE();
```

### Funkcje czasowe

```sql
-- Aktualna data i czas
SELECT 
    CURRENT_TIMESTAMP() AS CURRENT_TS,
    CURRENT_DATE() AS CURRENT_DATE,
    CURRENT_TIME() AS CURRENT_TIME;

-- Operacje na datach
SELECT 
    DATEADD('day', 30, CURRENT_DATE()) AS FUTURE_DATE,
    DATEDIFF('day', '2024-01-01', CURRENT_DATE()) AS DAYS_SINCE_NY;
```

### Funkcje konwersji

```sql
-- Konwersje typow
SELECT 
    TO_NUMBER('123.45') AS NUM_VALUE,
    TO_DATE('2024-01-15', 'YYYY-MM-DD') AS DATE_VALUE,
    TO_VARCHAR(CURRENT_DATE(), 'YYYY-MM-DD') AS STRING_DATE;
```

### 📚 Dodatkowe zasoby

- [System Functions](https://docs.snowflake.com/en/sql-reference/functions-system)
- [Date and Time Functions](https://docs.snowflake.com/en/sql-reference/functions-date-time)
- [Conversion Functions](https://docs.snowflake.com/en/sql-reference/functions-conversion)
- [Context Functions](https://docs.snowflake.com/en/sql-reference/functions/current_user)

## External Tables
Duration: 10

### Tworzenie External Table

```sql
-- UWAGA: Wymagane sa uprawnienia do Azure Storage Account
-- Opcja 1: Uzywanie SAS Token mniej bezpieczne
CREATE OR REPLACE STAGE MBANK_EXTERNAL_STAGE
URL = 'azure://mbankstorageacct.blob.core.windows.net/customer-data/'
CREDENTIALS = (AZURE_SAS_TOKEN = 'your-sas-token');

-- Opcja 2: Uzywanie Storage Integration rekomendowane
-- Najpierw stworz Storage Integration:
-- CREATE STORAGE INTEGRATION AZURE_INTEGRATION
--   TYPE = EXTERNAL_STAGE
--   STORAGE_PROVIDER = AZURE
--   ENABLED = TRUE
--   AZURE_TENANT_ID = 'your-tenant-id'
--   STORAGE_ALLOWED_LOCATIONS = 'azure://mbankstorageacct.blob.core.windows.net/customer-data/';

CREATE OR REPLACE STAGE MBANK_EXTERNAL_STAGE
URL = 'azure://mbankstorageacct.blob.core.windows.net/customer-data/'
STORAGE_INTEGRATION = AZURE_INTEGRATION;

-- External table dla plikow CSV z Azure
CREATE OR REPLACE EXTERNAL TABLE MBANK_EXTERNAL_CUSTOMERS (
    CUSTOMER_ID NUMBER AS (VALUE:c1::NUMBER),
    FIRST_NAME VARCHAR AS (VALUE:c2::VARCHAR),
    LAST_NAME VARCHAR AS (VALUE:c3::VARCHAR),
    EMAIL VARCHAR AS (VALUE:c4::VARCHAR)
)
LOCATION = @MBANK_EXTERNAL_STAGE
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);
```

### Zapytania do External Tables

```sql
-- Podstawowe zapytanie
SELECT * FROM MBANK_EXTERNAL_CUSTOMERS LIMIT 10;

-- Filtrowanie
SELECT FIRST_NAME, LAST_NAME 
FROM MBANK_EXTERNAL_CUSTOMERS 
WHERE EMAIL LIKE '%@mbank.pl';

-- Sprawdzenie metadanych plikow Azure
SELECT 
    FILE_NAME,
    FILE_SIZE,
    LAST_MODIFIED
FROM TABLE(INFORMATION_SCHEMA.EXTERNAL_TABLE_FILES(
    TABLE_NAME => 'MBANK_EXTERNAL_CUSTOMERS'
));
```

### Refresh External Tables

```sql
-- Odswiezenie metadanych
ALTER EXTERNAL TABLE MBANK_EXTERNAL_CUSTOMERS REFRESH;

-- Sprawdzenie statusu
SELECT * FROM TABLE(INFORMATION_SCHEMA.EXTERNAL_TABLE_FILES(
    TABLE_NAME => 'MBANK_EXTERNAL_CUSTOMERS'
));
```

### 📚 Dodatkowe zasoby

- [External Tables](https://docs.snowflake.com/en/user-guide/tables-external-intro)
- [CREATE EXTERNAL TABLE](https://docs.snowflake.com/en/sql-reference/sql/create-external-table)
- [File Formats](https://docs.snowflake.com/en/sql-reference/sql/create-file-format)
- [Stages](https://docs.snowflake.com/en/user-guide/data-load-considerations-stage)

## Dynamic Tables - Wprowadzenie
Duration: 10

### Możliwości Dynamic Tables

Dynamic Tables w Snowflake oferują następujące funkcjonalności:

**1. Automatyczne Odświeżanie**
- Dane są automatycznie aktualizowane zgodnie z TARGET_LAG
- Inteligentne incremental processing
- Optymalizacja kosztów przez odświeżanie tylko zmienionych danych

**2. Deklaratywne Podejście**
- Definicja zapytania SQL zamiast imperatywnych zadań
- Automatyczne zarządzanie zależnościami między tabelami
- Simplifikacja architektury ETL/ELT

**3. Wydajność**
- Materializowane wyniki dla szybkich zapytań
- Automatyczne tworzenie metadanych i statystyk
- Optymalizacja execution plans

**4. Monitorowanie i Zarządzanie**
- Built-in metryki wydajności i kosztów
- Historia odświeżania i diagnostyka
- Integracja z system functions

### Przykład Dynamic Table

**ℹ️ Informacja:** Minimalny TARGET_LAG w Snowflake to '1 minute'

```sql
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
```

### 📚 Dodatkowe zasoby

- [Dynamic Tables](https://docs.snowflake.com/en/user-guide/dynamic-tables-about)
- [CREATE DYNAMIC TABLE](https://docs.snowflake.com/en/sql-reference/sql/create-dynamic-table)
- [Dynamic Tables Best Practices](https://docs.snowflake.com/en/user-guide/dynamic-tables-best-practices)
- [Refresh Modes](https://docs.snowflake.com/en/user-guide/dynamic-tables-refresh)

## Dynamic Tables - Testowanie
Duration: 15

### Testowanie Dynamic Tables w akcji

Teraz przetestujemy jak Dynamic Tables reagują na zmiany danych:

```sql
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

-- OPCJONALNIE: Wymuszenie odswiezenia Dynamic Table (zamiast czekania na TARGET_LAG)
-- ALTER DYNAMIC TABLE MBANK_ACCOUNT_SUMMARY REFRESH;

-- Sprawdzenie czasu ostatniego odswiezenia
SELECT 
    NAME,
    LATEST_DATA_TIMESTAMP,
    DATEDIFF('minute', LATEST_DATA_TIMESTAMP, CURRENT_TIMESTAMP()) AS MINUTES_SINCE_REFRESH
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLES())
WHERE NAME = 'MBANK_ACCOUNT_SUMMARY';
```

**💡 Obserwacje podczas testowania:**
- Dynamic Tables odświeżają się automatycznie zgodnie z `TARGET_LAG`
- Zmiany w danych źródłowych są propagowane do Dynamic Tables
- Można wymusić natychmiastowe odświeżanie przez `ALTER DYNAMIC TABLE ... REFRESH`
- Można monitorować proces odświeżania przez `INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY()`
- TARGET_LAG to maksymalny dopuszczalny lag - rzeczywiste odświeżanie może być częstsze

### 📚 Dodatkowe zasoby

- [Dynamic Tables Testing](https://docs.snowflake.com/en/user-guide/dynamic-tables-refresh)
- [Monitoring Dynamic Tables](https://docs.snowflake.com/en/user-guide/dynamic-tables-refresh-history)
- [Information Schema Views](https://docs.snowflake.com/en/sql-reference/info-schema#dynamic-table-functions)

## Dynamic Table - Zalety
Duration: 4

### Korzyści z Dynamic Tables

**1. Automatyczne odświeżanie**
- Dane zawsze aktualne bez manualnej interwencji
- Optymalizacja kosztów przez inteligentne odświeżanie

**2. Wydajność**
- Materializowane wyniki dla szybkich zapytań
- Incremental processing

**3. Prostota zarządzania**
- Automatyczne zarządzanie cyklem życia
- Brak potrzeby tworzenia scheduled jobs

### Porównanie z tradycyjnymi rozwiązaniami

```sql
-- Tradycyjne podejscie scheduled task
CREATE OR REPLACE TASK REFRESH_SUMMARY_TASK
WAREHOUSE = COMPUTE_WH
SCHEDULE = '60 MINUTE'
AS
INSERT OVERWRITE INTO CUSTOMER_SUMMARY_TABLE 
SELECT ...;

-- Dynamic Table - automatyczne
CREATE OR REPLACE DYNAMIC TABLE CUSTOMER_SUMMARY_DT
TARGET_LAG = '1 minute'
WAREHOUSE = COMPUTE_WH
AS
SELECT ...;
```

### Best Practices

- Używaj odpowiedniego TARGET_LAG dla potrzeb biznesowych (minimum 1 minute)
- Monitoruj koszty warehouse - częstsze odświeżanie = wyższe koszty
- Optymalizuj zapytania bazowe
- Wykorzystuj partycjonowanie gdzie to możliwe

### 📚 Dodatkowe zasoby

- [Creating Dynamic Tables](https://docs.snowflake.com/en/user-guide/dynamic-tables-create)
- [Cost Considerations](https://docs.snowflake.com/en/user-guide/dynamic-tables-cost)
- [Dynamic Tables vs Streams & Tasks](https://docs.snowflake.com/en/user-guide/dynamic-tables-comparison)
- [Performance Optimization](https://docs.snowflake.com/en/user-guide/dynamic-table-performance-guide)

## Dynamic Table - Monitorowanie
Duration: 7

### Sprawdzanie statusu Dynamic Tables

```sql
-- Status wszystkich dynamic tables
SHOW DYNAMIC TABLES;

-- Szczegolowe informacje
SELECT 
    NAME,
    DATABASE_NAME,
    SCHEMA_NAME,
    TARGET_LAG_SEC,
    SCHEDULING_STATE,
    LATEST_DATA_TIMESTAMP
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLES());
```

### Historia odświeżania

```sql
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
```

### Metryki wydajności

```sql
-- Analiza wydajnosci odswiezania (ostatnie 7 dni)
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
```

### Alerting i monitoring

```sql
-- Sprawdzenie opoznien w odswiezaniu
SELECT 
    NAME,
    TARGET_LAG_SEC,
    DATEDIFF('minute', LATEST_DATA_TIMESTAMP, CURRENT_TIMESTAMP()) AS ACTUAL_LAG_MINUTES
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLES())
WHERE DATEDIFF('minute', LATEST_DATA_TIMESTAMP, CURRENT_TIMESTAMP()) > 
      (TARGET_LAG_SEC / 60) * 2;
```

### Monitorowanie przez interfejs Snowsight

**🖥️ Snowsight Web Interface - Monitoring Dynamic Tables:**

1. **Przejdź do zakładki "Data" → "Dynamic Tables"**
   - Lista wszystkich Dynamic Tables w Twojej bazie danych
   - Status każdej tabeli (Running, Suspended, Failed)
   - Ostatni czas odświeżenia i następne planowane odświeżenie

2. **Kliknij na konkretną Dynamic Table aby zobaczyć szczegóły:**
   - **Overview** - podstawowe informacje o tabeli
   - **Refresh History** - historia odświeżeń z wizualizacją czasów trwania
   - **Graph View** - wizualizacja zależności między tabelami
   - **Query Profile** - szczegółowa analiza wydajności zapytań odświeżających

3. **Refresh History Page - kluczowe funkcje:**
   - 📊 **Wykres czasów odświeżania** - łatwe wykrywanie anomalii wydajnościowych
   - 🔍 **Show Query Profile** - szczegółowa analiza każdego odświeżenia
   - ⚠️ **Source Data Timestamp** - sprawdzenie czy dane są aktualne
   - ❌ **Failed Refreshes** - identyfikacja problemów z odświeżaniem

4. **Graph View - wizualizacja zależności:**
   - Pokazuje powiązania między Dynamic Tables
   - Identyfikuje upstream/downstream dependencies
   - Pomaga w troubleshooting - failed upstream table blokuje downstream tables

**💡 Praktyczne wskazówki:**
- Regularnie sprawdzaj Refresh History dla wykrywania trendów wydajnościowych
- Używaj Query Profile do optymalizacji wolnych odświeżeń
- Monitoruj Graph View przy złożonych pipeline'ach z wieloma Dynamic Tables
- Skonfiguruj alerty dla failed refreshes przez Snowsight notifications

### 🚀 Rozszerzenie laboratorium - Zaawansowane Dynamic Tables

Po ukończeniu tego quickstartu, zalecamy przejście do oficjalnego **Snowflake Dynamic Tables Quickstart**, który pokrywa zaawansowane scenariusze:

**[Getting Started with Dynamic Tables - Snowflake Quickstart](https://quickstarts.snowflake.com/guide/getting_started_with_dynamic_tables/#0)**

**Co znajdziesz w rozszerzonym laboratorium:**

🔄 **Change Data Capture (CDC) Pipeline**
- Budowa pipeline'u CDC z użyciem Dynamic Tables
- Automatyczne przetwarzanie zmian w danych źródłowych
- Łączenie i agregacja danych z wielu źródeł

📊 **Zaawansowane przypadki użycia:**
- **Cumulative Sum** z użyciem Python UDTF
- **Data Validation** i automatyczne alerty
- **Inventory Management** - monitoring stanów magazynowych
- **DAG Visualization** - wizualizacja złożonych pipeline'ów

🐍 **Integracja z Python:**
- Snowpark User-Defined Table Functions (UDTF)
- Generowanie danych testowych z biblioteką Faker
- Modularyzacja logiki biznesowej

📧 **Alerting i Notifications:**
- Konfiguracja Snowflake Alerts
- Automatyczne powiadomienia email
- Monitoring jakości danych w czasie rzeczywistym

**Dlaczego warto kontynuować:**
- Praktyczne scenariusze biznesowe (e-commerce, retail)
- Kompleksowe pipeline'y danych z wieloma Dynamic Tables
- Best practices dla produkcyjnych wdrożeń
- Monitoring kosztów i wydajności

**Szacowany czas:** 60-90 minut  
**Poziom:** Średniozaawansowany do zaawansowanego

### 📚 Dodatkowe zasoby

- [Monitor Dynamic Tables](https://docs.snowflake.com/en/user-guide/dynamic-tables-monitor)
- [DYNAMIC_TABLES Function](https://docs.snowflake.com/en/sql-reference/functions/dynamic_tables)
- [DYNAMIC_TABLE_REFRESH_HISTORY](https://docs.snowflake.com/en/sql-reference/functions/dynamic_table_refresh_history)
- [Information Schema](https://docs.snowflake.com/en/sql-reference/info-schema)

## Podsumowanie
Duration: 2

### Podsumowanie

Gratulacje! Ukończyłeś mBank Snowflake Database Quickstart. Teraz znasz:

✅ **Database Objects and Commands** - podstawowe obiekty i komendy
✅ **Objects i Tables** - zarządzanie tabelami i obiektami  
✅ **Constraints i Views** - ograniczenia i widoki
✅ **System Functions** - funkcje systemowe Snowflake
✅ **External Tables** - integracja z zewnętrznymi źródłami danych
✅ **Dynamic Tables** - automatycznie odświeżane tabele
✅ **Monitoring** - śledzenie wydajności i kosztów

### Następne kroki

1. Eksploruj zaawansowane funkcje Snowflake
2. Zaimplementuj rozwiązania w swoim środowisku
3. Zoptymalizuj wydajność zapytań
4. Skonfiguruj monitoring i alerting

Dziękujemy za uczestnictwo w mBank Snowflake Quickstart! 🎉 