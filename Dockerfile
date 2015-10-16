FROM ruby:2.2.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libv8-dev
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
RUN bundle install
ADD . /myapp
