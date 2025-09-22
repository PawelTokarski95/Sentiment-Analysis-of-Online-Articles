FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --target=/install -r requirements.txt

COPY src/ ./src/
COPY execute.py .
COPY assets.py .

FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /install /usr/local/lib/python3.11/site-packages/

COPY --from=builder /app/src/ ./src/
COPY --from=builder /app/execute.py .
COPY --from=builder /app/assets.py .

EXPOSE 8000

CMD ["python", "-m", "uvicorn", "execute:app", "--host", "0.0.0.0", "--port", "8000"]
