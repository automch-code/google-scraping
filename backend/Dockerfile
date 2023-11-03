FROM ruby:3.2.1-bullseye

RUN apt-get update -qq && apt install -y libvips
WORKDIR /app
COPY backend/Gemfile /app/Gemfile
COPY backend/Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY backend/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]