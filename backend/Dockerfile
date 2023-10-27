FROM ruby:3.2.2-alpine3.18

RUN apk update -qq && \
    apk add make gcc g++ musl-dev vips postgresql-dev postgresql-client tzdata

WORKDIR /app
COPY backend/Gemfile /app/Gemfile
COPY backend/Gemfile.lock /app/Gemfile.lock
RUN bundle install --jobs=8

COPY backend/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 4000