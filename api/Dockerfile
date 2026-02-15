FROM ruby:3.3-slim

# Instala dependências de sistema necessárias para compilar gems nativas
# e conectar ao PostgreSQL
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libyaml-dev \
    git \
    curl \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia o Gemfile para instalar as gems
COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p 3000"]
