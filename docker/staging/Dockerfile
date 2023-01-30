FROM ruby:3.0.0-alpine as rubyonrails

COPY . /web

WORKDIR /web

ENV ALPINE_MIRROR="http://dl-cdn.alpinelinux.org/alpine"

RUN echo "${ALPINE_MIRROR}/v3.13/main" >> /etc/apk/repositories \
  && apk update \
  && apk add util-linux \
  && apk add --no-cache -t .build-dependencies build-base libxml2-dev libxslt-dev \
  && apk add --no-cache bash file imagemagick libpq sudo libxml2 libxslt nodejs mysql-client mysql-dev tini tzdata yarn linux-headers \
  && apk add --no-cache bash git openssh curl


FROM nginx:stable-alpine

COPY --from=rubyonrails . ./

WORKDIR /web

ENV RAILS_ENV="staging"

RUN gem install bundler:2.2.21 \
  && bundle lock --add-platform x86_64-linux-musl \
  && bundle config without 'development test' \
  && bundle config deployment true \
  && bundle install -j$(getconf _NPROCESSORS_ONLN)

RUN bundle exec bin/rails assets:precompile SECRET_KEY_BASE="tmp" \
  && rm -rf node_modules tmp/cache \
  && ln -sf /proc/1/fd/1 /var/log/nginx/access.log \
  && ln -sf /proc/1/fd/2 /var/log/nginx/error.log

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["/sbin/tini", "--"]
EXPOSE 80
