# sinatra_practice

## ローカルでの環境構築
```
$ bundle install
```
## データベースとの連携
PostgreSQLで下記のようにmemoテーブルを用意しておく。
```
CREATE TABLE memo (
  id bigseriarl,
  title text,
  body text,
  created_at timestamp,
  updated_at timestamp
);
```
ディレクトリ直下に`.env`ファイルを作成し、DBの接続情報を記入しておく。
```
DB_HOST = 'localhost'
DB_PORT = 5432
DB_NAME = 'db_name'
DB_USER = 'db_user'
DB_PASS = 'password'
```

## ローカルでのサーバ起動
```
$ bundle exec ruby app.rb
```
http://localhost:4567 にアクセス
