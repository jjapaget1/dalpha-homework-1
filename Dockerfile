FROM python:3.10-bullseye AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

# update and install packages
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    build-essential \
    awscli \
    zip \
    unzip \
    curl \
    git \
    software-properties-common \
    vim

RUN rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | POETRY_VERSION=1.8.3 python3 - && \
    echo 'export PATH="/root/.local/bin:$PATH"' >> /root/.bashrc && \
    echo 'export PATH="/root/.local/bin:$PATH"' >> /root/.profile

ENV PATH="/root/.local/bin:$PATH"

WORKDIR /workspace

COPY pyproject.toml poetry.lock /workspace/

RUN poetry lock --no-update --no-interaction --no-ansi -vvv

RUN poetry install --no-interaction --no-ansi -vvv

COPY . /workspace

CMD ["/bin/bash"]