FROM ruby:3.1-alpine

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN apk add --no-cache libc6-compat
RUN gem install bundler && bundle install -j4

COPY . /app

CMD /bin/sh
