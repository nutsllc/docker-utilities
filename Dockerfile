FROM alpine:3.4

ENV TERM=xterm
    GID=1000 \
    UID=1000 \
    GROUP_NAME=wheel \
    USER_NAME=tools

RUN apk add --no-cache \
        bash \
        sudo \
        tar \
        git \
        htop

RUN set -x \
    && adduser -u ${UID} -D -s /bin/bash -G ${GROUP_NAME} ${USER_NAME} \
    && echo "Defaults visiblepw" >> /etc/sudoers.d/default \
    && echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers.d/default \
    && echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/default

ENV JPEGOPTIM_VERSION 1.4.4
ENV OPTIPNG_VERSION 0.7.6
COPY src/optipng-${OPTIPNG_VERSION}.tar.gz /src/png.tar.gz

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

COPY docker-entrypoint.sh /entrypoint.sh
WORKDIR /home/${USER_NAME}
#USER tools

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]
