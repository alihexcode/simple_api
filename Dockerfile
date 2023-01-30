FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs git vim
RUN gem update bundler

RUN mkdir -p /web
WORKDIR /web

# Writing in wildcard allows the build to run successfully without a lock file
COPY Gemfile Gemfile.* ./

RUN bundle install
