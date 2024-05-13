##############################################################################
# Production Stage                                                           #
##############################################################################
ARG POSTGRES_MAJOR_VERSION=16

FROM postgres:$POSTGRES_MAJOR_VERSION-alpine AS postgres-backup-production

RUN apk update && apk add --no-cache python3 py3-pip vim gettext \
    && rm -rf /var/cache/apk/*

RUN pip3 install s3cmd python-magic --break-system-packages
RUN touch /var/log/cron.log

ENV \
    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

ADD build_data /build_data
ADD scripts /backup-scripts
RUN chmod 0755 /backup-scripts/*.sh

WORKDIR /backup-scripts

ENTRYPOINT ["/bin/bash", "/backup-scripts/start.sh"]
CMD []


##############################################################################
# Testing Stage                                                           #
##############################################################################
FROM postgres-backup-production AS postgres-backup-test

COPY scenario_tests/utils/requirements.txt /lib/utils/requirements.txt

RUN set -eux \
    && apk update \
    && apk add --no-cache python3 py3-pip \
    && rm -rf /var/cache/apk/*

RUN pip3 install -r /lib/utils/requirements.txt --break-system-packages
