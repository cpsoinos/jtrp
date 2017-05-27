FROM ruby:2.3.3
MAINTAINER corey@jtrpfurniture.com

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.

ARG SSH_KEY
# ENV MY_REPO git@github.com:cpsoinos/repo-name.git

RUN apt-get update && apt-get -y install openssh-client git-core &&\
    mkdir -p /root/.ssh && chmod 0700 /root/.ssh && \
    ssh-keyscan github.com >/root/.ssh/known_hosts

RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs

RUN echo "$SSH_KEY" >/root/.ssh/gem_key &&\
  chmod 0600 /root/.ssh/gem_key

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

RUN rm -f /root/.ssh/id_rsa

# Copy the main application.
COPY . ./

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
