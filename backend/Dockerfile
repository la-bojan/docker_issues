FROM bitwalker/alpine-elixir-phoenix:latest


RUN apk add --no-cache --update  \ 
 postgresql-client build-base 

WORKDIR /app


COPY mix.exs . 
COPY mix.lock .
COPY entrypoint.sh .

RUN chmod +x /app/entrypoint.sh

CMD "/app/entrypoint.sh"