FROM ruby:2.6.0

RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       apt-transport-https && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    apt-get install -y yarn

WORKDIR /app_name

COPY ./Gemfile /app_name/Gemfile
COPY ./Gemfile.lock /app_name/Gemfile.lock

RUN bundle install
COPY . $APP_ROOT

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]