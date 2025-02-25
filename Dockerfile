FROM python:3.11-slim as builder
RUN pip3 --disable-pip-version-check --no-cache-dir install transformers torch==2.6.0+cpu huggingface_hub --target=/deps
RUN mkdir -p /model && \
    python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='cointegrated/LaBSE-en-ru', local_dir='/model')"

FROM python:3.11-slim
RUN apt update && apt install python3.11-dev -y && rm -rf /var/lib/apt/lists/*
COPY --from=builder /deps /usr/local/lib/python3.11/site-packages
COPY --from=builder /model /app/model
ENV TRANSFORMERS_OFFLINE=1

# Add your application entrypoint here if needed
# ENTRYPOINT ["python3", "your_script.py"]