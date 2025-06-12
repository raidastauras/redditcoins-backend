# docker build -t us-central1-docker.pkg.dev/reddit-app-308612/backend/backend .
# docker push us-central1-docker.pkg.dev/reddit-app-308612/backend/backend
# docker pull us-central1-docker.pkg.dev/reddit-app-308612/backend/backend
# docker run -d us-central1-docker.pkg.dev/reddit-app-308612/backend/backend

FROM ubuntu:latest

WORKDIR /app

COPY private.py /app
COPY reddit_to_db.py /app
COPY /other_ops /app/other_ops

# install dependencies
RUN apt-get update && apt-get install -y python3-pip
RUN apt-get install -y python3-dev libpq-dev

# create python venv and install dependencies
RUN apt-get install -y python3-venv
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install psycopg psycopg2-binary asyncpg asyncpraw aiostream

# setup chron
RUN apt-get install -y cron
COPY crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab

CMD python3 -u reddit_to_db.py & cron -f
