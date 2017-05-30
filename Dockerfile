FROM ruby:2.3.3
MAINTAINER corey@jtrpfurniture.com

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
ENV app /app
RUN mkdir $app
WORKDIR $app

ENV BUNDLE_PATH /box
RUN gem install bundler

ADD . $app
