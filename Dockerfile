FROM python:3-alpine3.6
MAINTAINER Tobias L. Maier <me@tobiasmaier.info>

RUN apk add \
  bash \
  curl \
  grep

COPY merge-request.sh /usr/bin/

CMD merge-request.sh
