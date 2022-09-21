FROM ruby:3.1-alpine

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN apk add --no-cache libc6-compat && ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2
RUN gem install bundler && bundle install -j4

COPY . /app

CMD /bin/sh
