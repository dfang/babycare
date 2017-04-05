FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install nodejs nginx postgresql libpq-dev -y
RUN mkdir /fusion
WORKDIR /fusion
ADD Gemfile /fusion/Gemfile
ADD Gemfile.lock /fusion/Gemfile.lock
RUN bundle install
ADD . /fusion
