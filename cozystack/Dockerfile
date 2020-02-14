FROM debian:stable-slim AS installer

ARG COZY_VERSION=1.4.5
ARG NODE_VERSION=12.16.0

WORKDIR /tmp

RUN apt-get update && apt-get -y install wget xz-utils

COPY install.sh /
RUN chmod u+x /install.sh
RUN /install.sh

FROM debian:stable-slim

RUN apt-get update && apt-get -y install git imagemagick \
  && rm -rf /var/cache/apt
RUN groupadd --gid 1000 cozy && useradd --gid 1000 --uid 1000 -m -d /usr/local/cozy-stack cozy \
  && mkdir /etc/cozy && chown cozy:cozy /etc/cozy \
  && mkdir /usr/local/cozy-stack/scripts

COPY --chown=cozy:cozy --from=installer /tmp/cozy /usr/local/cozy-stack/cozy
COPY --chown=cozy:cozy --from=installer /tmp/node /usr/local/node
COPY --chown=cozy:cozy entrypoint.sh /entrypoint.sh
COPY --chown=cozy:cozy cozy.yaml /etc/cozy/cozy.yaml
ADD --chown=cozy:cozy https://raw.githubusercontent.com/cozy/cozy-stack/2018M2S5/scripts/konnector-node-run.sh /usr/local/cozy-stack/scripts/
## Workaround
#COPY --from=installer /tmp/cozy /usr/local/cozy-stack/cozy
#COPY --from=installer /tmp/node /usr/local/node
#COPY entrypoint.sh /entrypoint.sh
#COPY cozy.yaml /etc/cozy/cozy.yaml
#ADD https://raw.githubusercontent.com/cozy/cozy-stack/2018M2S5/scripts/konnector-node-run.sh /usr/local/cozy-stack/scripts/
#RUN chown cozy:cozy /usr/local/cozy-stack/cozy /usr/local/cozy-stack/scripts/konnector-node-run.sh /entrypoint.sh /etc/cozy/cozy.yaml
## End of the Workaround

RUN chmod u+x /entrypoint.sh /usr/local/cozy-stack/scripts/konnector-node-run.sh

# Raspberry hack for node
RUN ln -s /usr/local/node/bin/node /usr/bin/node

USER cozy

ENV COZY_ADMIN_PASSPHRASE=changeme

WORKDIR /usr/local/cozy-stack
ENTRYPOINT [ "/entrypoint.sh" ]
