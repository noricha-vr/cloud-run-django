# ベースイメージの指定
FROM python:3.11-slim-bullseye

# メンテナー情報（非推奨、LABELを使用することが推奨されます）
LABEL maintainer="sleepless-se"

# 必要なパッケージのインストール
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    locales \
    nginx \
    supervisor \
    sqlite3 \
    build-essential \
    libmariadb-dev \
    libsqlite3-dev \
    libjpeg-dev \
    tzdata && \
    rm -rf /var/lib/apt/lists/*

# 環境変数の設定
ENV LC_CTYPE='C.UTF-8'
ENV TZ=Asia/Tokyo

# uWSGIのインストール
RUN pip3 install uwsgi

# Nginxの設定
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx-app.conf /etc/nginx/sites-available/default

# Supervisorの設定
COPY supervisor-app.conf /etc/supervisor/conf.d/

# アプリケーションディレクトリの作成と設定
WORKDIR /app
COPY /requirements.txt /app/requirements.txt

# Python依存関係のインストール
RUN pip3 install -r /app/requirements.txt

# アプリケーションのコピー
COPY ./app /app
COPY uwsgi.ini /uwsgi.ini
COPY uwsgi_params /uwsgi_params

# ポートの公開
EXPOSE 8080

# Supervisorの実行
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
