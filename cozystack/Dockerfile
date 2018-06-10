FROM debian:stable-slim AS installer

ARG COZY_VERSION=2018M2S5

WORKDIR /tmp

RUN apt-get update && apt-get -y install wget 

COPY install.sh /
RUN chmod u+x /install.sh
RUN /install.sh

FROM debian:stable-slim

RUN apt-get update && apt-get -y install git && rm -rf /var/cache/apt
RUN groupadd --gid 1000 cozy && useradd --gid 1000 --uid 1000 -m -d /usr/local/cozy-stack cozy && mkdir /etc/cozy && chown cozy:cozy /etc/cozy

# Docker cloud still not support --chown option, even the edge version
#COPY --chown=cozy:cozy --from=installer /tmp/cozy /usr/local/cozy-stack/cozy
#COPY --chown=cozy:cozy entrypoint.sh /entrypoint.sh
#COPY --chown=cozy:cozy cozy.yaml /etc/cozy/cozy.yaml
## Workaround
COPY --from=installer /tmp/cozy /usr/local/cozy-stack/cozy
COPY entrypoint.sh /entrypoint.sh
COPY cozy.yaml /etc/cozy/cozy.yaml
RUN chown cozy:cozy /usr/local/cozy-stack/cozy /entrypoint.sh /etc/cozy/cozy.yaml 
## End of the Workaround

RUN chmod u+x /entrypoint.sh

USER cozy

ENV COZY_ADMIN_PASSPHRASE=changeme

WORKDIR /usr/local/cozy-stack
ENTRYPOINT [ "/entrypoint.sh" ]
