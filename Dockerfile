FROM ruby:3.4.4-alpine

ADD Gemfile /app/
ADD Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
    gem install bundler
    
RUN cd /app && \
    bundle config set --local path 'vendor/bundle' && \
    bundle config set --local frozen 'true' && \
    bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install

RUN apk del build-dependencies

ADD config.ru /app
ADD src/ /app/src
RUN chown -R nobody:nobody /app
USER nobody
EXPOSE 9292
WORKDIR /app

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "curl", "-f", "http://localhost:9292/api/status" ]

ENTRYPOINT ["bundle", "exec", "puma"]