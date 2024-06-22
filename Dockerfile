FROM python:3.11.9-alpine3.19

WORKDIR /app

ADD requirements.txt .

RUN apk add --no-cache --virtual .build-deps gcc build-base libffi-dev libretls-dev cargo && \
    pip install -r requirements.txt && \
    apk del .build-deps && \
    rm -rf /root/.cache /root/.cargo && \
    chown -R nobody:nogroup /app

COPY --chown=nobody:nogroup . .
COPY --chown=nobody:nogroup config.example.yml config.yml

USER nobody

ENTRYPOINT [ "python", "bot.py" ]
