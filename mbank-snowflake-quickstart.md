author: Pablo Mano
summary: Snowflake Database Quickstart Guide
id: snowflake-quickstart
categories: snowflake,database,sql
environments: web
status: Published
feedback link: https://github.com/sfc-gh-pmanowiecki/getstarted

# Snowflake Database Quickstart

## Introduction
Duration: 2

### What You'll Learn

W tym quickstarcie nauczysz się podstawowych konceptów i operacji w Snowflake, które są kluczowe dla pracy z bazami danych w środowisku mBank.

**Tematy, które omówimy:**
- Database Objects and Commands
- Objects and Tables
- Constraints and Views  
- System Functions
- External and Dynamic Tables
- Monitoring i optymalizacja

### Prerequisites

- Dostęp do Snowflake
- Podstawowa znajomość SQL
- Uprawnienia do tworzenia obiektów w bazie danych

## Database Objects and Commands
Duration: 5

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

-- Używanie bazy danych
USE DATABASE MBANK_DEMO;

-- Tworzenie schematu
CREATE SCHEMA QUICKSTART_SCHEMA;

-- Używanie schematu
USE SCHEMA QUICKSTART_SCHEMA;
```

### Ćwiczenie praktyczne

Wykonaj poniższe komendy w swojej sesji Snowflake:

```sql
-- Sprawdzenie dostępnych baz danych
SHOW DATABASES;

-- Sprawdzenie schematów
SHOW SCHEMAS;
```

## Objects
Duration: 4

### Zarządzanie obiektami

Snowflake oferuje bogate możliwości zarządzania obiektami bazodanowymi.

### Informacje o obiektach

```sql
-- Opis obiektu
DESCRIBE TABLE nazwa_tabeli;

-- Lista wszystkich tabel
SHOW TABLES;

-- Informacje o kolumnach
SHOW COLUMNS IN TABLE nazwa_tabeli;
```

### Uprawnienia

```sql
-- Przyznawanie uprawnień
GRANT SELECT ON TABLE nazwa_tabeli TO ROLE rola_użytkownika;

-- Sprawdzanie uprawnień
SHOW GRANTS ON TABLE nazwa_tabeli;
```

## Tables  
Duration: 8

### Tworzenie tabel

```sql
-- Podstawowa tabela
CREATE TABLE MBANK_CUSTOMERS (
    CUSTOMER_ID NUMBER(10,0),
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50), 
    EMAIL VARCHAR(100),
    PHONE_NUMBER VARCHAR(20),
    CREATED_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);
```

### Typy danych w Snowflake

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
(1, 'Jan', 'Kowalski', 'jan.kowalski@example.com', '+48123456789'),
(2, 'Anna', 'Nowak', 'anna.nowak@example.com', '+48987654321');
```

### Ćwiczenie

Stwórz tabelę `MBANK_ACCOUNTS` z kolumnami:
- ACCOUNT_ID (NUMBER)
- CUSTOMER_ID (NUMBER) 
- ACCOUNT_TYPE (VARCHAR)
- BALANCE (NUMBER(15,2))
- CREATED_DATE (TIMESTAMP_NTZ)

## Constraints
Duration: 6

### Rodzaje ograniczeń

Snowflake wspiera różne typy ograniczeń:

```sql
-- Primary Key
CREATE TABLE MBANK_PRODUCTS (
    PRODUCT_ID NUMBER(10,0) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRODUCT_TYPE VARCHAR(50),
    PRICE NUMBER(10,2) CHECK (PRICE > 0)
);
```

### Foreign Key

```sql
-- Dodanie klucza obcego
ALTER TABLE MBANK_ACCOUNTS 
ADD CONSTRAINT FK_CUSTOMER 
FOREIGN KEY (CUSTOMER_ID) 
REFERENCES MBANK_CUSTOMERS(CUSTOMER_ID);
```

### Check Constraints

```sql
-- Sprawdzenie wartości
ALTER TABLE MBANK_ACCOUNTS 
ADD CONSTRAINT CHK_BALANCE 
CHECK (BALANCE >= 0);
```

### Not Null

```sql
-- Kolumna nie może być pusta
ALTER TABLE MBANK_CUSTOMERS 
ALTER COLUMN EMAIL SET NOT NULL;
```

## Views
Duration: 5

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
```

### Secure Views

```sql
-- Bezpieczny widok (ukrywa definicję)
CREATE SECURE VIEW SENSITIVE_CUSTOMER_DATA AS
SELECT 
    CUSTOMER_ID,
    FIRST_NAME,
    SUBSTR(EMAIL, 1, 3) || '***' AS MASKED_EMAIL
FROM MBANK_CUSTOMERS;
```

### Materialized Views

```sql
-- Zmaterializowany widok dla wydajności
CREATE MATERIALIZED VIEW DAILY_ACCOUNT_SUMMARY AS
SELECT 
    DATE_TRUNC('DAY', CREATED_DATE) AS ACCOUNT_DATE,
    ACCOUNT_TYPE,
    COUNT(*) AS ACCOUNT_COUNT,
    AVG(BALANCE) AS AVG_BALANCE
FROM MBANK_ACCOUNTS
GROUP BY DATE_TRUNC('DAY', CREATED_DATE), ACCOUNT_TYPE;
```

## Using the Result_Scan Function
Duration: 4

### Funkcja RESULT_SCAN

RESULT_SCAN pozwala na wykorzystanie wyników poprzedniego zapytania:

```sql
-- Pierwsze zapytanie
SELECT CUSTOMER_ID, TOTAL_BALANCE 
FROM CUSTOMER_SUMMARY 
WHERE TOTAL_BALANCE > 10000;

-- Wykorzystanie wyników poprzedniego zapytania
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

-- Użycie konkretnego ID zapytania
SELECT * FROM TABLE(RESULT_SCAN('01234567-89ab-cdef-ghij-klmnopqrstuv'));
```

## System Functions
Duration: 6

### Funkcje informacyjne

```sql
-- Aktualna wersja Snowflake
SELECT CURRENT_VERSION();

-- Aktualny użytkownik i rola
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
-- Konwersje typów
SELECT 
    TO_NUMBER('123.45') AS NUM_VALUE,
    TO_DATE('2024-01-15', 'YYYY-MM-DD') AS DATE_VALUE,
    TO_VARCHAR(CURRENT_DATE(), 'YYYY-MM-DD') AS STRING_DATE;
```

## External Tables
Duration: 7

### Tworzenie External Table

```sql
-- Tworzenie stage dla zewnętrznych danych
CREATE OR REPLACE STAGE MBANK_EXTERNAL_STAGE
URL = 's3://mbank-data-bucket/customer-data/'
CREDENTIALS = (AWS_KEY_ID = 'your-key' AWS_SECRET_KEY = 'your-secret');

-- External table dla plików CSV
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
```

### Refresh External Tables

```sql
-- Odświeżenie metadanych
ALTER EXTERNAL TABLE MBANK_EXTERNAL_CUSTOMERS REFRESH;

-- Sprawdzenie statusu
SELECT * FROM TABLE(INFORMATION_SCHEMA.EXTERNAL_TABLE_FILES(
    TABLE_NAME => 'MBANK_EXTERNAL_CUSTOMERS'
));
```

## Dynamic Tables
Duration: 8

### Tworzenie Dynamic Tables

```sql
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
```

### Konfiguracja odświeżania

```sql
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
```

### Złożone Dynamic Tables

```sql
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
```

## Dynamic Table Advantages
Duration: 5

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
-- Tradycyjne podejście - scheduled task
CREATE OR REPLACE TASK REFRESH_SUMMARY_TASK
WAREHOUSE = COMPUTE_WH
SCHEDULE = '60 MINUTE'
AS
INSERT OVERWRITE INTO CUSTOMER_SUMMARY_TABLE 
SELECT ...;

-- Dynamic Table - automatyczne
CREATE OR REPLACE DYNAMIC TABLE CUSTOMER_SUMMARY_DT
TARGET_LAG = '1 hour'
WAREHOUSE = COMPUTE_WH
AS
SELECT ...;
```

### Best Practices

- Używaj odpowiedniego TARGET_LAG dla potrzeb biznesowych
- Monitoruj koszty warehouse
- Optymalizuj zapytania bazowe
- Wykorzystuj partycjonowanie gdzie to możliwe

## Monitoring Dynamic Tables
Duration: 6

### Sprawdzanie statusu Dynamic Tables

```sql
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
```

### Historia odświeżania

```sql
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
```

### Metryki wydajności

```sql
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
```

### Alerting i monitoring

```sql
-- Sprawdzenie opóźnień w odświeżaniu
SELECT 
    NAME,
    TARGET_LAG,
    DATEDIFF('minute', LAST_DATA_TIMESTAMP, CURRENT_TIMESTAMP()) AS ACTUAL_LAG_MINUTES
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLES())
WHERE DATEDIFF('minute', LAST_DATA_TIMESTAMP, CURRENT_TIMESTAMP()) > 
      EXTRACT(MINUTE FROM TARGET_LAG) * 2;
```

## Conclusion
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

### Dodatkowe zasoby

- [Snowflake Documentation](https://docs.snowflake.com/)
- [mBank Technical Guidelines](https://mbank-tech-docs.internal)
- [SQL Best Practices](https://best-practices.mbank.internal)

Dziękujemy za uczestnictwo w mBank Snowflake Quickstart! 🎉 