FROM ubuntu:18.04
MAINTAINER Yongjia Niu, ahnniu@gmail.com


# Install essential Yocto Project host packages
# Clean up the apt cache by removing /var/lib/apt/lists toreduces the image size
# Install repo tool with tinghua mirror: https://mirrors.tuna.tsinghua.edu.cn/git/git-repo
# Origin: http://commondatastorage.googleapis.com/git-repo-downloads/repo
# See: https://mirrors.tuna.tsinghua.edu.cn/help/git-repo/
# Create a non-root user that will perform the actual build
# Fix error "Please use a locale setting which supports utf-8."
# See https://wiki.yoctoproject.org/wiki/TipsAndTricks/ResolvingLocaleIssues
RUN apt-get update && apt-get install -y \
        build-essential \
        chrpath \
        diffstat \
        gawk \
        libncurses5-dev \
        python3-distutils \
        texinfo \
        bc \
        libssl-dev \
        openssl \
        zlib1g \
        zlib1g-dev \
        nano \
        wget \
        git \
        unzip \
        sed \
        curl \
        cpio \
        cmake \
        sudo \
        locales \
        proxychains4 \
 && rm -rf /var/lib/apt/lists/* \
 && curl https://mirrors.tuna.tsinghua.edu.cn/git/git-repo > /usr/bin/repo \
 && chmod a+x /usr/bin/repo \
 && id build 2>/dev/null || useradd --create-home build \
 && echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers \
 && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
 && echo 'LANG="en_US.UTF-8"'>/etc/default/locale \
 && dpkg-reconfigure --frontend=noninteractive locales \
 && update-locale LANG=en_US.UTF-8

# Install ccls
RUN git clone --depth=1 --recursive https://github.com/MaskRay/ccls \
&& cd ccls \
&& wget -c http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz \
&& tar xf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz \
&& cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DUSE_SYSTEM_RAPIDJSON=OFF -DCMAKE_PREFIX_PATH=$PWD/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04 \
&& cmake --build Release \
&& cmake --build Release --target install \
&& cd && rm -rf ccls

# Install Bear
RUN git clone --depth=1 git@github.com:rizsotto/Bear.git \
&& BEAR_SOURCE_DIR=/root/Bear \
&& mkdir tmp && cd tmp \
&& cmake $BEAR_SOURCE_DIR \
&& make all \
&& make install \
&& cd && rm -rf tmp Bear


ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

USER build
WORKDIR /home/build
CMD "/bin/bash"




