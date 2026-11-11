
FROM python:3.15-slim

# Katalog roboczy aplikacji
WORKDIR /app

# Biblioteki potrzebne do instalacji mysqlclient
RUN apt-get update && apt-get install -y \
    gcc \
    pkg-config \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalacja zależności Pythona
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Kopiowanie aplikacji
COPY . .

# Przygotowanie plików statycznych
RUN python manage.py collectstatic --noinput

# Port aplikacji
EXPOSE 8000

# Uruchomienie aplikacji
CMD ["gunicorn", "mysite.wsgi:application", "--bind", "0.0.0.0:8000"]
