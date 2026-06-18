FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    jq \
    && rm -rf /var/lib/apt/lists/*

RUN echo "layer-2-timestamp: $(date +%s)" > /build-info.txt

COPY README.md /app/README.md

CMD ["cat", "/build-info.txt"]
