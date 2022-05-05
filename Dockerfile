FROM debian:latest

RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y install bash git \
       curl wget openssl libpq-dev libssl-dev zlib1g-dev locales build-essential \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

