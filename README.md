# cloud-run-training

Cloud Run Training

## リポジトリを clone

```bash
$ git clone https://github.com/xxxxx/cloud-run-training.git
```

## GitHubの設定

```bash
$ git config user.name {GitHubのアカウント名}
$ git config user.email {GitHubのemail}
```

## イメージの作成

```bash
$ docker build -t ws-flask-app:local .
```

## ビルドしたイメージの確認

```bash
$ docker images
```

## ビルドしたイメージからコンテナを立ち上げる

```bash
$ docker run -p 8080:8080 -v $(pwd)/app:/app -e DEBUG=true ws-flask-app:local
```

## Artifact Registry にイメージをアップ

### イメージのパスを構成

```plain
{リポジトリのパス}/{アプリ名}:{タグ名}
```

例

```plain
asia-northeast1-docker.pkg.dev/xxxxxxxxxxx/repo-xxxxxx-xxxxxxxx/ws-flask-app:latest
```

記入欄

```plain
xxxxx/ws-flask-app:latest
```

### イメージのビルド

```bash
$ docker build -t {イメージのパス} .
```

例

```bash
$ docker build -t asia-northeast1-docker.pkg.dev/xxxxxxxxxxx/repo-xxxxxx-xxxxxxxx/ws-flask-app:latest .
```

記入欄

```plain
docker build -t xxxxx/ws-flask-app:latest
```

作成したイメージをリポジトリに置く

```bash
$ docker push {イメージのパス}
```

例

```bash
$ docker push asia-northeast1-docker.pkg.dev/xxxxxxxxxxx/repo-xxxxxx-xxxxxxxx/ws-flask-app:latest .
```

記入欄

```plain
docker push xxxxx/ws-flask-app:latest
```

## Cloud Runにデプロイ

```bash
$ gcloud run deploy {アプリ名} \
    --image {イメージのパス} \
    --region asia-northeast1
    --port 8080
```

例

```bash
$ gcloud run deploy cloud-run-xxxxx \
    --image asia-northeast1-docker.pkg.dev/xxxxxxxxxxx/repo-xxxxxx-xxxxxxxx/ws-flask-app:latest \
    --region asia-northeast1
    --port 8080
```

記入欄

```bash
$ gcloud run deploy cloud-run-xxxxx \
    --image xxxxxxx \
    --region asia-northeast1
    --port 8080
```

## Cloud Runで立ち上がっているアプリにアクセス

```bash
$ gcloud run services proxy {アプリ名} --region asia-northeast1
```

例

```bash
$ gcloud run services proxy cloud-run-xxxxxx --region asia-northeast1
```

記入欄

```bash
$ gcloud run services proxy xxxxxx --region asia-northeast1
```
