FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y nodejs yarnpkg
RUN ln -s /usr/bin/yarnpkg /usr/bin/yarn
RUN mkdir /RailsDockerTutorial
WORKDIR /RailsDockerTutorial
COPY Gemfile /RailsDockerTutorial/Gemfile
COPY Gemfile.lock /RailsDockerTutorial/Gemfile.lock

RUN gem update --system \
    && gem install bundler --pre \
    && bundle install -j 4

COPY . /RailsDockerTutorial

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
