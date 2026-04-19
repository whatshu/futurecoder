FROM python:3.12.1-bookworm

ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG ALL_PROXY
ARG NO_PROXY
ARG http_proxy
ARG https_proxy
ARG all_proxy
ARG no_proxy
ARG FUTURECODER_LANGUAGE=en
ARG FUTURECODER_LANGUAGES=en
ARG REACT_APP_LANGUAGE=en

ENV DEBIAN_FRONTEND=noninteractive
ENV POETRY_VIRTUALENVS_CREATE=false
ENV POETRY_NO_INTERACTION=1
ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}
ENV ALL_PROXY=${ALL_PROXY}
ENV NO_PROXY=${NO_PROXY}
ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}
ENV all_proxy=${all_proxy}
ENV no_proxy=${no_proxy}
ENV FUTURECODER_LANGUAGE=${FUTURECODER_LANGUAGE}
ENV FUTURECODER_LANGUAGES=${FUTURECODER_LANGUAGES}
ENV REACT_APP_LANGUAGE=${REACT_APP_LANGUAGE}

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get update && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir poetry

WORKDIR /app

COPY pyproject.toml poetry.lock ./
RUN poetry install \
    && pip install --no-cache-dir "packaging>=24.2"

COPY . .

RUN ./scripts/generate.sh

WORKDIR /app/frontend
RUN if [ -n "$HTTP_PROXY" ]; then npm config set proxy "$HTTP_PROXY"; fi \
    && if [ -n "$HTTPS_PROXY" ]; then npm config set https-proxy "$HTTPS_PROXY"; fi \
    && npm config set fetch-retries 5 \
    && npm config set fetch-retry-mintimeout 20000 \
    && npm config set fetch-retry-maxtimeout 120000
RUN npm ci
RUN npm run build

EXPOSE 3000

CMD sh -c 'cd /app && FIX_CORE_IMPORTS=1 poetry run python -m translations.generate_po_file && FIX_CORE_IMPORTS=1 poetry run python -m scripts.generate_static_files && cp -f /app/frontend/course/service-worker.js /app/frontend/public/service-worker.js 2>/dev/null || true && npm --prefix /app/frontend start -- --host 0.0.0.0'
