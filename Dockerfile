FROM python:3.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    CHROME_BINARY=/usr/bin/chromium \
    HOME=/home/appuser \
    WEB_HOST=0.0.0.0 \
    WEB_PORT=5001

WORKDIR /app

RUN apt-get update \
    && apt-get install --no-install-recommends -y chromium chromium-driver \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN mkdir -p /app/data /app/cache /app/logs /home/appuser \
    && chown -R 99:100 /app /home/appuser

# Unraid creates appdata folders as nobody:users (99:100).
USER 99:100

EXPOSE 5001

CMD ["python", "app.py"]
