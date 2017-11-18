FROM ruby:2.4

RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb \
  && dpkg -i dumb-init_*.deb \
  && rm dumb-init_*.deb

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

ENTRYPOINT ["dumb-init", "--"]
