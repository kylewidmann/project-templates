ARG PROJECT_DIR
ARG PROJECT

FROM python:3.12-slim-bookworm AS base

ENV \
  PYTHONUNBUFFERED=1 \
  PYTHONDONTWRITEBYTECODE=1 \
  POETRY_VERSION=2.1.3 \
  POETRY_VIRTUALENVS_IN_PROJECT=true \
  POETRY_NO_INTERACTION=1 \
  POETRY_HOME="/opt/poetry" \
  POETRY="/opt/poetry/bin/poetry"

ENV PATH="$POETRY_HOME/bin:$PATH"

ARG PROJECT_DIR
ARG PROJECT

USER root

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 - \
    && chmod a+x /opt/poetry/bin/poetry

WORKDIR /app

# Install workspace deps (root pyproject + the target package)
COPY pyproject.toml poetry.toml poetry.lock* ./
COPY src/${PROJECT_DIR}/ ./src/${PROJECT_DIR}/
RUN poetry install --only main

##################################################
## PRODUCTION
##################################################

FROM python:3.12-slim-bookworm AS production

ARG PROJECT_DIR
ARG PROJECT

ENV PATH="/app/.venv/bin:$PATH"
ENV APP_USER=app APP_GROUP=app

USER root

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd ${APP_GROUP} \
    && useradd -g ${APP_GROUP} ${APP_USER}

WORKDIR /app
COPY --from=base /app/.venv ./.venv
COPY src/${PROJECT_DIR}/ ./src/${PROJECT_DIR}/

USER ${APP_USER}

ENTRYPOINT ["python", "-m", "{{cookiecutter.package_slug}}"]

##################################################
## DEVELOPMENT
##################################################

FROM base AS development

ARG PROJECT_DIR
ARG PROJECT

ENV PATH="/app/.venv/bin:$PATH"
ENV APP_USER=app APP_GROUP=app

RUN groupadd ${APP_GROUP} \
    && useradd -g ${APP_GROUP} ${APP_USER}

WORKDIR /app
COPY pyproject.toml poetry.toml poetry.lock* ./
COPY src/${PROJECT_DIR}/ ./src/${PROJECT_DIR}/
RUN poetry install
RUN chown -R ${APP_USER}:${APP_GROUP} .

USER ${APP_USER}

ENTRYPOINT ["python", "-m", "{{cookiecutter.package_slug}}"]
