# 公式Pythonイメージを使用
FROM python:3.11-alpine

# 環境変数を設定（コンテナ）
ENV PYTHONNUNBUFFERED=True
ENV APP_HOME=/app

# 作業ディレクトリを設定（コンテナ）
WORKDIR $APP_HOME

# PostgreSQL開発依存関係をインストール
RUN apk add --no-cache postgresql-dev gcc python3-dev musl-dev

# アプリケーションコードをコピー（ホストマシンからコンテナ）
COPY app/ .

# 依存関係をインストール（コンテナ）
RUN pip install -r requirements.txt

# コンテナをサーバーとして実行するよう設定（コンテナ）
EXPOSE 8080

# Webサービスを実行（コンテナ）
CMD ["gunicorn", "--bind", ":8080", "--workers", "1", "--threads", "8", "--timeout", "0", "main:app"]
