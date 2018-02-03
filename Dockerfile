# https://github.com/docker-library/python/blob/master/Dockerfile-alpine.template
FROM alpine:3.7

ARG HOME="/root"
ARG PROFILE="$HOME/.profile"
ARG PYENV_COMMIT="f1145576982ab3bdc62bc96596302792872c5e66"
ARG PYENV_ROOT="$HOME/pyenv"

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# https://github.com/pyenv/pyenv/wiki/Common-build-problems
RUN apk add --no-cache --virtual .build-deps  \
    bash=4.4.12-r2 \
    binutils-libs=2.28-r3 \
    binutils=2.28-r3 \
    bzip2-dev=1.0.6-r6 \
    ca-certificates=20171114-r0 \
    coreutils=8.28-r0 \
    dpkg-dev=1.18.24-r0 \
    dpkg=1.18.24-r0 \
    expat-dev=2.2.5-r0 \
    expat=2.2.5-r0 \
    fontconfig-dev=2.12.6-r0 \
    fontconfig=2.12.6-r0 \
    freetype-dev=2.8.1-r2 \
    freetype=2.8.1-r2 \
    gcc=6.4.0-r5 \
    gdbm-dev=1.13-r1 \
    gdbm=1.13-r1 \
    git=2.15.0-r1 \
    gmp=6.1.2-r1 \
    inputproto=2.3.2-r1 \
    isl=0.18-r0 \
    kbproto=1.0.7-r2 \
    libacl=2.2.52-r3 \
    libatomic=6.4.0-r5 \
    libattr=2.4.47-r6 \
    libbsd=0.8.6-r1 \
    libbz2=1.0.6-r6 \
    libc-dev=0.7.1-r0 \
    libcap=2.25-r1 \
    libcurl=7.57.0-r0 \
    libffi-dev=3.2.1-r4 \
    libffi=3.2.1-r4 \
    libgcc=6.4.0-r5 \
    libgomp=6.4.0-r5 \
    libhistory=7.0.003-r0 \
    libpng-dev=1.6.34-r1 \
    libpng=1.6.34-r1 \
    libpthread-stubs=0.3-r4 \
    libressl-dev=2.6.3-r0 \
    libressl2.6-libtls=2.6.3-r0 \
    libressl=2.6.3-r0 \
    libssh2=1.8.0-r2 \
    libstdc++=6.4.0-r5 \
    libx11-dev=1.6.5-r1 \
    libx11=1.6.5-r1 \
    libxau-dev=1.0.8-r2 \
    libxau=1.0.8-r2 \
    libxcb-dev=1.12-r1 \
    libxcb=1.12-r1 \
    libxdmcp-dev=1.1.2-r4 \
    libxdmcp=1.1.2-r4 \
    libxft-dev=2.3.2-r2 \
    libxft=2.3.2-r2 \
    libxrender-dev=0.9.10-r2 \
    libxrender=0.9.10-r2 \
    linux-headers=4.4.6-r2 \
    make=4.2.1-r0 \
    mpc1=1.0.3-r1 \
    mpfr3=3.1.5-r1 \
    musl-dev=1.1.18-r2 \
    ncurses-dev=6.0_p20171125-r0 \
    ncurses-libs=6.0_p20171125-r0 \
    ncurses-terminfo-base=6.0_p20171125-r0 \
    ncurses-terminfo=6.0_p20171125-r0 \
    patch=2.7.5-r1 \
    pax-utils=1.2.2-r1 \
    pcre2=10.30-r0 \
    perl=5.26.1-r1 \
    pkgconf=1.3.10-r0 \
    readline-dev=7.0.003-r0 \
    readline=7.0.003-r0 \
    renderproto=0.11.1-r3 \
    sqlite-dev=3.21.0-r0 \
    sqlite-libs=3.21.0-r0 \
    tcl-dev=8.6.7-r0 \
    tcl=8.6.7-r0 \
    tk-dev=8.6.6-r1 \
    tk=8.6.6-r1 \
    xcb-proto=1.12-r1 \
    xextproto=7.3.0-r2 \
    xf86bigfontproto-dev=1.2.0-r5 \
    xproto=7.0.31-r1 \
    xtrans=1.3.5-r1 \
    xz-dev=5.2.3-r1 \
    xz-libs=5.2.3-r1 \
    xz=5.2.3-r1 \
    zlib-dev=1.2.11-r1

# https://github.com/pyenv/pyenv#basic-github-checkout
# The git option '--shallow-submodules' is not supported in this version.
RUN git clone --recursive --shallow-submodules \
        https://github.com/pyenv/pyenv.git \
        $PYENV_ROOT

# Enforce configured commit.
RUN cd $PYENV_ROOT && \
    git reset --hard $PYENV_COMMIT && \
    cd $HOME

# Convenient environment when ssh-ing into the container.
RUN echo "export PYENV_ROOT=$PYENV_ROOT" >> $PROFILE
RUN echo 'export PATH=$PYENV_ROOT/bin:$PATH' >> $PROFILE
RUN echo 'eval "$(pyenv init -)"' >> $PROFILE

ENTRYPOINT ["/bin/bash", "--login", "-i", "-c"]
CMD ["bash"]
