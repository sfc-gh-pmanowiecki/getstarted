# mBank Snowflake Database Quickstart

Interaktywny quickstart guide do nauki podstaw Snowflake, przygotowany specjalnie dla mBank.

## 📋 Wymagania

- **claat** - Google Codelabs tool
- **Go** - do instalacji claat
- **Python** - do lokalnego serwera (opcjonalne)
- **Przeglądarka internetowa**

## 🚀 Instalacja i uruchomienie

### 1. Instalacja claat

```bash
# Instalacja Go (jeśli nie jest zainstalowane)
# https://golang.org/doc/install

# Instalacja claat
go install github.com/googlecodelabs/tools/claat@latest
```

### 2. Budowanie codelaba

#### Linux/macOS:
```bash
chmod +x build-codelab.sh
./build-codelab.sh
```

#### Windows:
```cmd
build-codelab.bat
```

### 3. Uruchomienie

Po zbudowaniu, otwórz plik `mbank-snowflake-quickstart/index.html` w przeglądarce lub uruchom lokalny serwer:

```bash
cd mbank-snowflake-quickstart
python -m http.server 8000
# Następnie otwórz http://localhost:8000
```

## 📚 Struktura projektu

```
├── mbank-snowflake-quickstart.md    # Główny plik źródłowy (Markdown)
├── mbank-styles.css                 # Customowe style mBank
├── mBank_logo.png                   # Logo mBank
├── build-codelab.sh                 # Skrypt budujący (Linux/macOS)
├── build-codelab.bat                # Skrypt budujący (Windows)
├── requrements.md                   # Lista tematów
└── README.md                        # Ten plik
```

## 🎯 Zawartość quickstartu

1. **Database Objects and Commands** - Podstawowe obiekty i komendy
2. **Objects** - Zarządzanie obiektami bazodanowymi
3. **Tables** - Tworzenie i zarządzanie tabelami
4. **Constraints** - Ograniczenia i walidacja danych
5. **Views** - Widoki i wirtualne tabele
6. **Using the Result_Scan Function** - Wykorzystanie funkcji RESULT_SCAN
7. **System Functions** - Funkcje systemowe Snowflake
8. **External Tables** - Tabele zewnętrzne
9. **Dynamic Tables** - Dynamiczne tabele
10. **Dynamic Table Advantages** - Korzyści z Dynamic Tables
11. **Monitoring Dynamic Tables** - Monitorowanie i optymalizacja

## 🎨 Stylizacja

Codelab używa customowych stylów mBank z:
- **Kolorami marki**: Zielony (#00a651), Pomarańczowy (#ff6b35)
- **Logo mBank** w nagłówku
- **Responsywnym designem**
- **Podświetlaniem składni SQL**

## 🔧 Customizacja

### Zmiana treści
Edytuj plik `mbank-snowflake-quickstart.md` i przebuduj codelab.

### Zmiana stylów
Modyfikuj `mbank-styles.css` i przebuduj codelab.

### Dodanie nowych sekcji
1. Dodaj nową sekcję do pliku Markdown
2. Dodaj czas trwania: `Duration: X`
3. Przebuduj codelab

## 📊 Metadane codelaba

- **ID**: mbank-snowflake-quickstart
- **Kategorie**: snowflake, database, sql
- **Status**: Published
- **Środowisko**: web
- **Czas trwania**: ~60 minut

## 🔍 Troubleshooting

### claat nie jest rozpoznany
```bash
# Sprawdź czy GOPATH/bin jest w PATH
echo $PATH | grep -o "$(go env GOPATH)/bin"

# Jeśli nie, dodaj do ~/.bashrc czy ~/.zshrc
export PATH=$PATH:$(go env GOPATH)/bin
```

### Błędy budowania
1. Sprawdź czy wszystkie pliki są obecne
2. Upewnij się, że claat jest najnowsza wersja
3. Sprawdź składnię Markdown w pliku źródłowym

### Problemy ze stylami
1. Sprawdź czy `mbank-styles.css` jest skopiowany
2. Sprawdź czy link do CSS jest w HTML
3. Wyczyść cache przeglądarki
