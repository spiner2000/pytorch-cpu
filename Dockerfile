# Dockerfile
FROM python:3.11-slim as builder
RUN pip install transformers torch --target=/deps

FROM python:3.11-slim
COPY --from=builder /deps /usr/local/lib/python3.11/site-packages