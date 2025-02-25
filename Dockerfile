# Dockerfile
FROM python:3.11-slim as builder
RUN pip3 --disable-pip-version-check --no-cache-dir  install transformers --target=/deps
RUN pip3 --disable-pip-version-check --no-cache-dir  install torch==2.6.0+cpu --target=/deps --index-url https://download.pytorch.org/whl/cpu

FROM python:3.11-slim
RUN apt update && apt install python3.11-dev -y 
COPY --from=builder /deps /usr/local/lib/python3.11/site-packages