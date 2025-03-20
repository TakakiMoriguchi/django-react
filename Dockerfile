# Pythonベースのイメージ
FROM python:3.11

EXPOSE 8080
ENV PORT=8080
ENV GUNICORN_CMD_ARGS="--bind 0.0.0.0:$PORT"

# Node.jsを追加インストール
RUN apt-get update && apt-get install -y curl && \
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
  apt-get install -y nodejs

# 作業ディレクトリ
WORKDIR /app

# 必要なファイルをコピー
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Djangoプロジェクトをコピー
COPY . .

# Reactのビルド（必要なら）
WORKDIR /app/frontend
RUN npm install && npm run build

# 環境変数設定
ENV DJANGO_SETTINGS_MODULE=config.settings.production

# スタートアップコマンド
# CMD ["python", "manage.py","runserver","0.0.0.0:{$PORT}"]
CMD ["gunicorn", "--bind", "0.0.0.0:${PORT}", "config.wsgi:application"]
