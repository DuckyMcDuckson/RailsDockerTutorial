# Rails Tutorial
クローン後に以下のコマンドで空の Rails が起動。 URL は `localhost:3000` 。

```ps1
docker-compose run --no-deps web rails new . --force --database=mysql
docker-compose build
docker-compose run web rails db:create
docker-compose up
```

元記事: https://techtechmedia.com/migrate-to-docker-mysql/
