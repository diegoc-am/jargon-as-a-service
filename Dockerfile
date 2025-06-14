FROM ruby:3.4.4-alpine

ADD Gemfile /app/
ADD Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
    gem install bundler && \
    cd /app
    
RUN bundle install --without development test 

RUN apk del build-dependencies

ADD config.ru /app
ADD src/ /app/src
RUN chown -R nobody:nobody /app
USER nobody
EXPOSE 9292
WORKDIR /app

ENTRYPOINT ["bundle", "exec", "puma"]