FROM alpine:3.6
MAINTAINER Tobias L. Maier <me@tobiasmaier.info>

RUN apk add --no-cache \
  bash \
  curl \
  grep \
  jq

COPY merge-request.sh /usr/bin/

CMD ["merge-request.sh"]
