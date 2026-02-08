# Development Dockerfile
FROM ruby:3.3-slim

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    postgresql-client \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /rails

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application
COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
