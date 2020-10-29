FROM python:3.9.0-slim-buster

WORKDIR /app

# Needed to install uWSGI
RUN apt-get update && apt-get install -y gcc

COPY requirements.txt ./requirements.txt

RUN pip install -r requirements.txt

COPY . .

ENV NEW_RELIC_LOG=stdout \
    NEW_RELIC_DISTRIBUTED_TRACING_ENABLED=true \
    NEW_RELIC_APP_NAME="Patrick Harakiri Test" \
    NEW_RELIC_ENVIRONMENT=production \
    DEBUG=1

CMD [ \
    "newrelic-admin", \
    "run-program", \
    "uwsgi", \
    "--module=config.wsgi:application", \
    "--env", "DJANGO_SETTINGS_MODULE=config.settings", \
    "--http=0.0.0.0:8000", \
    "--harakiri=5", "--harakiri-verbose", \
    "--master", \
    "--enable-threads", "--single-interpreter" \
]