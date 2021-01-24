FROM ruby:2.7.0-alpine

ARG workdir=/var/www/authentication

RUN apk add --update \
  build-base \
  mysql-dev \
  file \
  git \
  bash \
  tzdata \
  && rm -rf /var/cache/apk/*

COPY Gemfile* /tmp/
WORKDIR /tmp

RUN gem install bundler
RUN bundle install

RUN mkdir -p $workdir

WORKDIR $workdir
ADD . $workdir

RUN mkdir -p tmp/pids
