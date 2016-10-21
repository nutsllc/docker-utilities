FROM alpine:3.4

# ---------------------------------------------------------
# Base
# ---------------------------------------------------------
RUN apk add --no-cache \
        bash \
        sudo \
        tar

ENV TERM=xterm \
    GID=1000 \
    UID=1000 \
    GROUP_NAME=wheel \
    USER_NAME=tools

# ---------------------------------------------------------
# User
# ---------------------------------------------------------
RUN set -x \
    && adduser -u ${UID} -D -G ${GROUP_NAME} ${USER_NAME} \
    && echo "Defaults visiblepw" >> /etc/sudoers.d/default \
    && echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers.d/default \
    && echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/default

# ---------------------------------------------------------
# vim
# ---------------------------------------------------------
#ENV VIM_VERSION=8.0
ENV VIM_VERSION=7.4
RUN apk add --update --no-cache --virtual=build-dependencies \
        gcc \
        g++ \
        make \ 
        ncurses-dev \
        lua-dev \
    && mkdir -p /src/vim \
    && wget http://ftp.vim.org/pub/vim/unix/vim-${VIM_VERSION}.tar.bz2 -O /src/vim/vim-${VIM_VERSION}.tar.bz2 \
    && tar xjf /src/vim/vim-${VIM_VERSION}.tar.bz2 -C /src/vim \
    && cd /src/vim/vim$(echo ${VIM_VERSION} | sed -e "s/\.//" ) \
    && ./configure \
            --with-features=huge \
            --enable-multibyte \
            --enable-luainterp=dynamic \
            --enable-gpm \
            --enable-cscope \
            --enable-fontset \
    && make -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && make install \
    && cd / \
    && rm -rf /src \
    && apk del --purge build-dependencies


# ---------------------------------------------------------
# jpegoptim & optipng
# ---------------------------------------------------------
#ENV JPEGOPTIM_VERSION=1.4.4 \
#    OPTIPNG_VERSION=0.7.6
#
#COPY src/optipng-${OPTIPNG_VERSION}.tar.gz /src/png.tar.gz
#RUN apk add --update --no-cache --virtual=build-dependencies \
#        gcc \
#        g++ \
#        make \ 
#        ncurses-dev \
#        lua-dev 
#    && git clone https://github.com/vim/vim.git /src/vim \
#    && cd /src/vim \
#    && ./configure \
#            --with-features=huge \
#            --enable-multibyte \
#            --enable-luainterp=dynamic \
#            --enable-gpm \
#            --enable-cscope \
#            --enable-fontset \
#    && make -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
#    && make install \
#    && apk add --no-cache libjpeg-turbo-dev libpng-dev \
#    && wget http://www.kokkonen.net/tjko/src/jpegoptim-${JPEGOPTIM_VERSION}.tar.gz -O /src/jpeg.tar.gz \
#    && tar xzf /src/jpeg.tar.gz -C /src \
#    && cd /src/jpegoptim-${JPEGOPTIM_VERSION} \
#    && ./configure \
#    && make -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
#    && make install \
#    && tar xzf /src/png.tar.gz -C /src \
#    && cd /src/optipng-${OPTIPNG_VERSION} \
#    && ./configure \
#    && make -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
#    && make install \
#    && cd / \
#    && rm -rf /src \
#    && apk del --purge build-dependencies

# ---------------------------------------------------------
# node.js
# ---------------------------------------------------------

# ENV VERSION=v0.10.47 CFLAGS="-D__USE_MISC" NPM_VERSION=2
# ENV VERSION=v0.12.16 NPM_VERSION=2
# ENV VERSION=v4.6.0 NPM_VERSION=2
# ENV VERSION=v5.12.0 NPM_VERSION=3
ENV VERSION=v6.8.1 NPM_VERSION=3

# For base builds
# ENV CONFIG_FLAGS="--without-npm" RM_DIRS=/usr/include
#ENV CONFIG_FLAGS="--fully-static --without-npm" DEL_PKGS="libgcc libstdc++" RM_DIRS=/usr/include
ENV CONFIG_FLAGS="--fully-static" DEL_PKGS="libgcc libstdc++" RM_DIRS=/usr/include

RUN apk add --no-cache curl make gcc g++ python linux-headers paxctl libgcc libstdc++ gnupg && \
  gpg --keyserver ha.pool.sks-keyservers.net --recv-keys \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 && \
  curl -o node-${VERSION}.tar.gz -sSL https://nodejs.org/dist/${VERSION}/node-${VERSION}.tar.gz && \
  curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/${VERSION}/SHASUMS256.txt.asc && \
  gpg --verify SHASUMS256.txt.asc && \
  grep node-${VERSION}.tar.gz SHASUMS256.txt.asc | sha256sum -c - && \
  tar -zxf node-${VERSION}.tar.gz && \
  cd node-${VERSION} && \
  export GYP_DEFINES="linux_use_gold_flags=0" && \
  ./configure --prefix=/usr ${CONFIG_FLAGS} && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  make -j${NPROC} -C out mksnapshot BUILDTYPE=Release && \
  paxctl -cm out/Release/mksnapshot && \
  make -j${NPROC} && \
  make install && \
  paxctl -cm /usr/bin/node && \
  cd / && \
  if [ -x /usr/bin/npm ]; then \
    npm install -g npm@${NPM_VERSION} && \
    find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
  fi && \
  apk del curl make gcc g++ python linux-headers paxctl gnupg ${DEL_PKGS} && \
  rm -rf /etc/ssl /node-${VERSION}.tar.gz /SHASUMS256.txt.asc /node-${VERSION} ${RM_DIRS} \
    /usr/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /root/.gnupg \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html




#RUN apk add --no-cache --virtual=build-dependencies \
#        gcc \
#        g++ \
#        make \
#        python \
#        linux-headers \
#        wget \
#        ca-certificates
#RUN mkdir -p /src
#RUN wget https://nodejs.org/dist/v4.6.0/node-v4.6.0.tar.gz -O /src/nodejs.tar.gz \
#    && tar xzf /src/nodejs.tar.gz -C /src
#RUN cd /src/node-v${NODE_VERSION} \
#    && ./configure \
#            --prefix=/usr/local/node-v${NODE_VERSION} \
#            --without-snapshot \
#    && make -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
#    && make install \
#    && apk del build-dependencies
#RUN cd / && rm -rf \
#        /src \
#        /etc/ssl \
#        /usr/local/node-v${NODE_VERSION}/include/ \
#        /usr/local/node-v${NODE_VERSION}/share/man/ \
#        /usr/local/node-v${NODE_VERSION}/lib/node_modules/npm/man  \
#        /usr/local/node-v${NODE_VERSION}/lib/node_modules/npm/doc \
#        /usr/local/node-v${NODE_VERSION}/lib/node_modules/npm/html
#ENV PATH=${PATH}:/usr/local/node-v${NODE_VERSION}/bin \
#    NODE_PATH=/home/${USER_NAME}/.node_modules

# ---------------------------------------------------------
# post build
# ---------------------------------------------------------
COPY docker-entrypoint.sh /entrypoint.sh
WORKDIR /home/${USER_NAME}
USER tools

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]
