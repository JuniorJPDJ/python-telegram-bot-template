FROM        python:3.12.4-alpine3.19@sha256:ff8436b0f58e915d812627de599608a86eb36522fae3fd9be3561bdd8eb6673a

# renovate: datasource=repology depName=alpine_3_20/gcc versioning=loose
ARG         GCC_VERSION="13.2.1_git20240309-r0"
# renovate: datasource=repology depName=alpine_3_20/build-base versioning=loose
ARG         BUILD_BASE_VERSION="13.2.1_git20240309-r0"
# renovate: datasource=repology depName=alpine_3_20/libffi-dev versioning=loose
ARG         LIBFFI_VERSION="13.2.1_git20240309-r0"
# renovate: datasource=repology depName=alpine_3_20/libretls-dev versioning=loose
ARG         LIBRETLS_VERSION="13.2.1_git20240309-r0"
# renovate: datasource=repology depName=alpine_3_20/cargo versioning=loose
ARG         CARGO_VERSION="13.2.1_git20240309-r0"

WORKDIR     /app

ADD         requirements.txt .

RUN         apk add --no-cache --virtual .build-deps \
              gcc=${GCC_VERSION} \
              build-base=${BUILD_BASE_VERSION} \
              libffi-dev=${LIBFFI_VERSION} \
              libretls-dev=${LIBRETLS_VERSION} \
              cargo=${CARGO_VERSION} \
            && \
            pip install -r requirements.txt && \
            apk del .build-deps && \
            rm -rf /root/.cache /root/.cargo && \
            chown -R nobody:nogroup /app

COPY        --chown=nobody:nogroup . .
COPY        --chown=nobody:nogroup config.example.yml config.yml

USER        nobody

ENTRYPOINT  [ "python", "bot.py" ]
