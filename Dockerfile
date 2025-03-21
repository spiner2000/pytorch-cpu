# Dockerfile
FROM python:3.11-slim as builder
RUN pip3 --disable-pip-version-check install torch==2.6.0+cpu --target=/deps --index-url https://download.pytorch.org/whl/cpu
RUN pip3 --disable-pip-version-check install transformers --target=/deps
# RUN pip3 --disable-pip-version-check install sentence-transformers[onnx] --target=/deps

FROM python:3.11-slim as model_downloader
RUN pip3 --disable-pip-version-check install huggingface_hub
RUN mkdir -p /model && \
    python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2', local_dir='/model')"

    FROM python:3.11-slim
RUN apt update && apt install python3.11-dev -y 
COPY --from=builder /deps /usr/local/lib/python3.11/site-packages
COPY --from=model_downloader /model /app/model
# ENV TRANSFORMERS_OFFLINE=1