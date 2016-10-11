FROM alpine:3.4

ENV GID 1000
ENV UID 1000

ENV GROUP_NAME tools
ENV USER_NAME tools

RUN set -x \
    && addgroup -g ${GID} -S ${GROUP_NAME} \
    && adduser -u ${UID} -D -s /bin/bash -G ${GROUP_NAME} ${USER_NAME}

RUN apk add --no-cache \
        bash \
        sudo \
        tar \
        git \
        htop \
        nmap

ENV JPEGOPTIM_VERSION 1.4.4
ENV OPTIPNG_VERSION 0.7.6
COPY optipng-${OPTIPNG_VERSION}.tar.gz /src/png.tar.gz

# vim & jpegoptim & optipng
RUN apk add --update --no-cache --virtual=build-dependencies \
        gcc \
        g++ \
        make \
        ncurses-dev \
        lua-dev \
    && git clone https://github.com/vim/vim.git /src/vim \
    && cd /src/vim \
    && ./configure \
            --with-features=huge \
            --enable-multibyte \
            --enable-luainterp=dynamic \
            --enable-gpm \
            --enable-cscope \
            --enable-fontset \
    && make && make install \
    && apk add --no-cache libjpeg-turbo-dev libpng-dev \
    && wget http://www.kokkonen.net/tjko/src/jpegoptim-${JPEGOPTIM_VERSION}.tar.gz -O /src/jpeg.tar.gz \
    && tar xzf /src/jpeg.tar.gz -C /src \
    && tar xzf /src/png.tar.gz -C /src \
    && cd /src/jpegoptim-${JPEGOPTIM_VERSION} \
    && ./configure && make && make install \
    && cd /src/optipng-${OPTIPNG_VERSION} \
    && ./configure && make && make install \
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* \
    && cd / && rm -rf /src

WORKDIR /home/${USER_NAME}
USER tools
