FROM alpine:latest
WORKDIR /tmp
ARG CYTUBE_MARIADB_PASSWORD CYTUBE_URL CYTUBE_TITLE CYTUBE_DESC YOUTUBE_V3_API_KEY TWITCH_CLIENT_ID
RUN apk add --no-cache build-base git mariadb-client python3 npm yq uuidgen ffmpeg
RUN git clone -b 3.0 https://github.com/calzoneman/sync
RUN cd sync && npm install
COPY sync/config.template.yaml sync/config.yaml
COPY toml_configs /tmp/sync/conf/
RUN mkdir /service && cp -r /tmp/sync /service/
RUN cd /service/sync && npm install -g forever
RUN export UUID=$(uuidgen) && cd /service/sync && \
  yq -i ".mysql.server = \"db\"" config.yaml && \
  yq -i ".mysql.password = \"$CYTUBE_MARIADB_PASSWORD\"" config.yaml && \
  yq -i ".http.root-domain = \"$CYTUBE_URL\"" config.yaml && \
  yq -i ".http.trust-proxies[0] = \"loopback\"" config.yaml && \
  yq -i ".http.trust-proxies[1] = \"uniquelocal\"" config.yaml && \
  yq -i ".http.cookie-secret = \"$UUID\"" config.yaml && \
  yq -i ".io.domain = \"https://$CYTUBE_URL\"" config.yaml && \
  yq -i ".io.default-port = 443" config.yaml && \
  yq -i ".listen[1].port = 443" config.yaml && \
  yq -i ".html-template.title = \"$CYTUBE_TITLE\"" config.yaml && \
  yq -i ".html-template.description = \"$CYTUBE_DESC\"" config.yaml && \
  yq -i ".ffmpeg.enabled = \"true\"" config.yaml && \
  yq -i ".youtube-v3-key = \"$YOUTUBE_V3_API_KEY\"" config.yaml && \
  yq -i ".twitch-client-id = \"$TWITCH_CLIENT_ID\"" config.yaml
RUN echo -e "#!/bin/sh\nexport NODE_ENV=production && cd /service/sync && forever index.js" > /start.sh && chmod +x /start.sh
ENTRYPOINT ["/bin/sh", "/start.sh"]
