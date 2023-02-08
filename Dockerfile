FROM debian:latest AS base

RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y install bash git \
       curl wget openssl libpq-dev libssl-dev zlib1g-dev locales \
       build-essential poppler-utils imagemagick tzdata \
       unzip gnupg jq less libyaml libyaml-dev \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists /tmp/* /var/tmp/*

RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen

ENV HOME /root
ENV PATH $HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
ENV PATH $HOME/.nodenv/bin:$HOME/.nodenv/shims:$PATH
ENV SHELL /bin/bash
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN git clone https://github.com/nodenv/nodenv.git ~/.nodenv
RUN echo 'export PATH="~/.nodenv/bin:$PATH"; eval "$(nodenv init -)"' > /etc/profile.d/nodenv_init.sh
RUN mkdir -p "$(nodenv root)"/plugins
RUN git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build
RUN git clone https://github.com/nodenv/nodenv-aliases.git $(nodenv root)/plugins/nodenv-aliases
RUN nodenv install 18.0.0

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'export PATH="~/.rbenv/bin:$PATH"; eval "$(rbenv init -)"' > /etc/profile.d/rbenv_init.sh
RUN mkdir -p "$(rbenv root)"/plugins
RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
RUN rbenv install 3.1.1

WORKDIR /tmp/awscli
COPY aws-cli.key .
RUN gpg --import aws-cli.key && \
    curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
    curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig -o awscliv2.sig && \
    gpg --verify awscliv2.sig awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install && \
    cd / && rm -rf /tmp/awscli

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable
RUN echo "CHROME_BIN=/usr/bin/google-chrome" | tee -a /etc/environment
RUN rm -f /etc/cron.daily/google-chrome /etc/apt/sources.list.d/google-chrome.list /etc/apt/sources.list.d/google-chrome.list.save

RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/
RUN echo "CHROMEWEBDRIVER=/usr/local/bin/chrome_driver" | tee -a /etc/environment

ENV DISPLAY=:99

WORKDIR /srv
