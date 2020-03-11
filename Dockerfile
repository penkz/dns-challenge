FROM ruby:2.6.5

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /dns-challenge
WORKDIR /dns-challenge
RUN gem install bundler
COPY Gemfile /dns-challenge/Gemfile
COPY Gemfile.lock /dns-challenge/Gemfile.lock
RUN bundle install
COPY . /dns-challenge
