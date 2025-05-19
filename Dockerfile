# Stage 1: Ruby 2.7 Webapp (Apple Silicon compatible)
FROM ruby:2.7 AS webapp

# Install system dependencies and ARM-compatible Chromium
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    libvips \
    libvips-dev \
    chromium \
    chromium-driver

# Set working directory
WORKDIR /openfarm

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.3.26
RUN bundle config build.nokogiri --use-system-libraries \
  && bundle install --jobs 4 --retry 3

# Copy the rest of the app
COPY . .

# Set Puppeteer environment in case it's used
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Start the Rails server
CMD ["rails", "s", "-b", "0.0.0.0"]
