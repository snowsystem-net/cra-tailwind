FROM node:14.19-buster
WORKDIR /workspace/app

# -------------------------------------------------
# [1] 初期構築
# -------------------------------------------------

RUN apt-get update
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8 \
    LANGUAGE ja_JP:ja \
    LC_ALL ja_JP.UTF-8 \
    TZ JST-9
RUN apt-get install -y vim
