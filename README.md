# Rails Tutorial
クローン後に以下のコマンドで空の Rails が起動。 URL は `localhost:3000` 。

```ps1
docker-compose run --no-deps web rails new . --force --database=mysql
docker-compose build
docker-compose run --rm web rails db:create
docker-compose run --rm web bin/rails tailwindcss:install
docker-compose run --rm web bin/rails tailwindcss:build
docker-compose up
```

## Reference
- [【MySQL】RailsアプリケーションをDocker環境下で動かすまでの手順を解説｜TechTechMedia](https://techtechmedia.com/migrate-to-docker-mysql/)
  - Docker での Rails 環境構築についての記事。
- [Ruby on Rails (7.0) の実践的な開発手法に触れてみよう](https://zenn.dev/tmasuyama1114/books/ab51fea5d5f659)
  - 「Chapter 10 2-7. Tailwind CSS とは」まで実装。
- [【Rails7】ついにDeviseがTurboに対応しました（最新版v4.9.0のリリース） | こばっちブログ](https://kobacchi.com/rails7-devise-finally-responded-to-turbo/)
  - ユーザ認証。
