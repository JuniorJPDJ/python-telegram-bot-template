FROM python:3.12.4-alpine3.19@sha256:ff8436b0f58e915d812627de599608a86eb36522fae3fd9be3561bdd8eb6673a

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
