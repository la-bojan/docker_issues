FROM elixir:latest

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

RUN mkdir assets

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y inotify-tools && \
    apt-get install -y nodejs && \
    curl -L https://npmjs.org/install.sh | sh && \
    mix local.hex --force && \
    mix archive.install hex phx_new 1.5.3 --force && \
    mix local.rebar --force


COPY assets/package.json assets

CMD mix deps.get && cd assets && npm install && npm rebuild node-sass && cd .. && mix phx.server



