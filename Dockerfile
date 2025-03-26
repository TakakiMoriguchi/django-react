# フロントエンド（React）ビルド
FROM node:18 AS frontend-build

# まずclientディレクトリをコピー
COPY client /app/client
# 作業ディレクトリを変更
WORKDIR /app/client
# npmコマンドを実行
RUN npm install && npm run build

# 最終ステージ（Cloud Run 用）
FROM python:3.11-slim

# システムパッケージのインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの設定
WORKDIR /app

COPY . .

# 依存関係をインストール
RUN pip install --no-cache-dir -r requirements.txt gunicorn whitenoise

# フロントエンドのビルド成果物を Django の staticfiles にコピー
COPY --from=frontend-build /app/client /app/staticfiles

# 必要なポートを公開（Cloud Run の環境変数に対応）
ENV PORT=8080
EXPOSE 8080

# Cloud Run では 1プロセスのみ実行可能なため gunicorn を使用
CMD ["gunicorn", "-b", "0.0.0.0:8080", "config.wsgi:application"]