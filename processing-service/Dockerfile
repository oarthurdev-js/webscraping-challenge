# Development Dockerfile
FROM ruby:3.3-slim

# Install dependencies including Chromium for Ferrum
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y \
  build-essential \
  libpq-dev \
  libyaml-dev \
  postgresql-client \
  git \
  chromium \
  ca-certificates \
  fonts-liberation \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libcups2 \
  libdbus-1-3 \
  libexpat1 \
  libfontconfig1 \
  libgbm1 \
  libgtk-3-0 \
  libnspr4 \
  libnss3 \
  libpango-1.0-0 \
  libx11-6 \
  libxcb1 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxi6 \
  libxrandr2 \
  libxrender1 \
  libxss1 \
  libxtst6 \
  && rm -rf /var/lib/apt/lists/*

ENV FERRUM_BROWSER_PATH=/usr/bin/chromium

WORKDIR /rails

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application
COPY . .

EXPOSE 3000
CMD ["bash", "-c", "bundle install && rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"]
