FROM ruby:2.5.1
RUN mkdir /price_tracker
WORKDIR /price_tracker
COPY Gemfile /price_tracker/Gemfile
COPY Gemfile.lock /price_tracker/Gemfile.lock
RUN bundle install
COPY . /price_tracker

RUN rm -rf log/*

COPY migrate.sh /usr/bin/
RUN chmod +x /usr/bin/migrate.sh

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
