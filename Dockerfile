FROM ruby:2.5.1
RUN mkdir /bargain
WORKDIR /bargain
COPY Gemfile /bargain/Gemfile
COPY Gemfile.lock /bargain/Gemfile.lock
RUN bundle install
COPY . /bargain

RUN rm -rf log/*

COPY migrate.sh /usr/bin/
RUN chmod +x /usr/bin/migrate.sh

RUN curl -s -o /usr/bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x /usr/bin/wait-for-it.sh

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
