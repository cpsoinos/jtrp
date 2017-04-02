# Base our image on an official, minimal image of our preferred Ruby
FROM ruby:2.3.1-slim

# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  postgresql-client \
  nodejs \
  libmagickwand-dev \
  imagemagick \
  libcurl4-openssl-dev

# Define where our application will live inside the image
ENV RAILS_ROOT /home/jtrp
ENV BUNDLE_PATH /bundle

# Create application home. App server will need the pids dir so just create everything in one shot
RUN mkdir -p $RAILS_ROOT/tmp/pids

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler

# Copy the Rails application into place
# COPY . .
ADD . $RAILS_ROOT
RUN chmod +x script/start
RUN chown -R $USER:$USER .

# Define the script we want run once the container boots
# Use the "exec" form of CMD so our script shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD ["rails", "server", "--binding", "0.0.0.0"]
