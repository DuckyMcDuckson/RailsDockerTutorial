# 変更点
## `rubocop` が動作しない問題の回避
`AllCops -> Exclude` があると `bundle exec rubocop` が何も出力せず、終了もしない状態になった。

以下を `.rubocop.yml` に追加すると解決した。

```yml
inherit_mode:
  merge:
    - Exclude
```

`AllCops -> Exclude` などのリストが rubocop のデフォルト設定と被ると正しく動作しないとのこと。

- [RuboCop - [AllCops -> Exclude] not working in GitHub Actions - Stack Overflow](https://stackoverflow.com/a/70818366)
- [.rubocop.yml exclude doesn't work. · Issue #227 · rubyide/vscode-ruby · GitHub](https://github.com/rubyide/vscode-ruby/issues/227)
- [Configuration :: RuboCop Docs](https://docs.rubocop.org/rubocop/configuration.html#merging-arrays-using-inherit_mode)

## `rubocop` による CR 文字欠落の指摘を停止
Windows 環境では rubocop がデフォルトで CR 文字 (Carriage Return) の欠落を指摘する。 LF 文字のみでの改行に統一しているため、以下のルールを追加した。

```yml
Layout/EndOfLine:
  EnforcedStyle: lf
```

## `rubocop` の `Rails/FilePath` を無効化
Ruby は OS によらずパスのデリミタに `/` を使っているので、わざわざ `Rails.root.join()` を使う必要はない。また `Rails/FilePath` の指摘は自動生成されたファイル `spec/rails_helper.rb` に対して行われたが、問題があったときに `rubocop` が挟まっていると調べるものが一つ増えてしまう、つまり `rails` や `rspec` のバグである可能性に加えて `rubocop` のバグである可能性を考慮しなければならなくなるので、無効が適切と判断した。

```yml
Rails/FilePath:
  Enabled: false
```

- [ruby - Why does rubocop's Rails/FilePath cop recommend Rails.root.join - Stack Overflow](https://stackoverflow.com/questions/48026807/why-does-rubocops-rails-filepath-cop-recommend-rails-root-join)
- [path - slash and backslash in Ruby - Stack Overflow](https://stackoverflow.com/questions/7173000/slash-and-backslash-in-ruby)

## RSpec でテストに使うブラウザを指定しない
参考文献の以下のページには「Headless モードへ変更」の節がある。

- [2-6. 統合テスト (System Spec)｜Ruby on Rails (7.0) の実践的な開発手法に触れてみよう](https://zenn.dev/tmasuyama1114/books/ab51fea5d5f659/viewer/558883#headless-%E3%83%A2%E3%83%BC%E3%83%89%E3%81%B8%E5%A4%89%E6%9B%B4)

今回は Docker 上で開発しており、そもそもブラウザが立ち上がらなかったため、「Headless モードへ変更」の節に書いてある変更は行わなかった。

以下は変更を試した際に出力されたエラーメッセージ。

<details>
<summary>エラーメッセージ</summary>

```
# bin/rspec spec/system/home_spec.rb
Running via Spring preloader in process 178

Home
  トップページの検証
2023-02-24 07:09:01 WARN Selenium [:logger_info] Details on how to use and modify Selenium logger:
  https://selenium.dev/documentation/webdriver/troubleshooting/logging#ruby

2023-02-24 07:09:01 WARN Selenium [DEPRECATION] [:capabilities] The :capabilities parameter for Selenium::WebDriver::Chrome::Driver is deprecated. Use :options argument with an instance of Selenium::WebDriver::Chrome::Driver instead.
2023-02-24 07:09:01 WARN Selenium [DEPRECATION] [:capabilities] The :capabilities parameter for Selenium::WebDriver::Chrome::Driver is deprecated. Use :options argument with an instance of Selenium::WebDriver::Chrome::Driver instead.
    Home#top という文字列が表示される (FAILED - 1)

Failures:

  1) Home トップページの検証 Home#top という文字列が表示される
     Got 0 failures and 2 other errors:

     1.1) Failure/Error: visit '/'

          Webdrivers::BrowserNotFound:
            Failed to determine Chrome binary location.
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chrome_finder.rb:21:in `location'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chrome_finder.rb:10:in `version'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chromedriver.rb:51:in `browser_version'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chromedriver.rb:142:in `browser_build_version'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chromedriver.rb:32:in `latest_version'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/common.rb:122:in `download_version'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/common.rb:134:in `correct_binary?'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/common.rb:91:in `update'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chromedriver.rb:156:in `block in <main>'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/service.rb:103:in `binary_path'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/service.rb:74:in `initialize'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/service.rb:32:in `new'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/service.rb:32:in `chrome'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/chrome/driver.rb:35:in `initialize'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/driver.rb:47:in `new'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/driver.rb:47:in `for'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver.rb:88:in `for'
          # /usr/local/bundle/gems/capybara-3.38.0/lib/capybara/selenium/driver.rb:83:in `browser'
          # /usr/local/bundle/gems/capybara-3.38.0/lib/capybara/selenium/driver.rb:104:in `visit'
          # /usr/local/bundle/gems/capybara-3.38.0/lib/capybara/session.rb:280:in `visit'
          # /usr/local/bundle/gems/capybara-3.38.0/lib/capybara/dsl.rb:52:in `call'
          # /usr/local/bundle/gems/capybara-3.38.0/lib/capybara/dsl.rb:52:in `visit'
          # ./spec/system/home_spec.rb:14:in `block (3 levels) in <main>'
          # /usr/local/bundle/gems/spring-commands-rspec-1.0.4/lib/spring/commands/rspec.rb:18:in `load'
          # /usr/local/bundle/gems/spring-commands-rspec-1.0.4/lib/spring/commands/rspec.rb:18:in `call'
          # -e:1:in `<main>'

     1.2) Failure/Error: raise BrowserNotFound, 'Failed to determine Chrome binary location.'

          Webdrivers::BrowserNotFound:
            Failed to determine Chrome binary location.
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chrome_finder.rb:21:in `location'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chrome_finder.rb:10:in `version'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chromedriver.rb:51:in `browser_version'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chromedriver.rb:142:in `browser_build_version'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chromedriver.rb:32:in `latest_version'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/common.rb:122:in `download_version'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/common.rb:134:in `correct_binary?'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/common.rb:91:in `update'
          # /usr/local/bundle/gems/webdrivers-5.2.0/lib/webdrivers/chromedriver.rb:156:in `block in <main>'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/service.rb:103:in `binary_path'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/service.rb:74:in `initialize'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/service.rb:32:in `new'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/service.rb:32:in `chrome'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/chrome/driver.rb:35:in `initialize'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/driver.rb:47:in `new'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver/common/driver.rb:47:in `for'
          # /usr/local/bundle/gems/selenium-webdriver-4.8.1/lib/selenium/webdriver.rb:88:in `for'
          # /usr/local/bundle/gems/capybara-3.38.0/lib/capybara/selenium/driver.rb:83:in `browser'
          # /usr/local/bundle/gems/capybara-3.38.0/lib/capybara/selenium/driver.rb:161:in `save_screenshot'
          # /usr/local/bundle/gems/capybara-3.38.0/lib/capybara/session.rb:747:in `block in save_screenshot'
          # /usr/local/bundle/gems/capybara-3.38.0/lib/capybara/session.rb:747:in `save_screenshot'
          # /usr/local/bundle/gems/spring-commands-rspec-1.0.4/lib/spring/commands/rspec.rb:18:in `load'
          # /usr/local/bundle/gems/spring-commands-rspec-1.0.4/lib/spring/commands/rspec.rb:18:in `call'
          # -e:1:in `<main>'

Finished in 0.54242 seconds (files took 2.86 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/system/home_spec.rb:13 # Home トップページの検証 Home#top という文字列が表示される
```

</details>

## tailwindcss のインストール
Docker Desktop の Rails のコンテナのターミナルで以下を入力すると tailwindcss が使えるようになった。

```sh
./bin/bundle add tailwindcss-rails # (1)
./bin/rails tailwindcss:install
```

(1) のコマンドによって `Gemfile` に以下の行が追加される。

```ruby
gem 'tailwindcss-rails', '~> 2.0'
```

上記のコマンドは以下のドキュメンテーションの「2 Install Tailwind CSS」に記載されていた。

- [Install Tailwind CSS with Ruby on Rails - Tailwind CSS](https://tailwindcss.com/docs/guides/ruby-on-rails)

## RSpec のテストでのユーザ認証
Devise の `:confirmable` を設定しているので `create()` によって作成したユーザを認証する必要がある。以下のように `user.confirm` を使えば RSpec のテスト内でユーザ認証できる。

```ruby
context 'SomeTest' do
  before do
    user = create(:user)
    user.confirm
    # `sign_in user` などが続く。
  end
end
```

- [RSpec初心者のdevise認証システムテスト - Qiita](https://qiita.com/zongxiaojie/items/d488edd42ba3864859c7)

メール認証の場合、以下のように送信したメールの認証 URL を訪れることもできる。

```ruby
describe 'OtherTest' do
  before do
    ActionMailer::Base.deliveries.clear
    create(:user, name:, email:, password:, password_confirmation: password)

    # Visit confimation URL in mail.
    visit ActionMailer::Base.deliveries.last.body.encoded.[](/http[^"]+/)

    # ...
  end
end
```

- [Devise confirmable用のテスト（フィーチャスペック）を書く（解説動画付き） - Qiita](https://qiita.com/jnchito/items/64f4cde336632f9a4890)

# その他
## データベースのリセット
今のところはデータを消去しても問題ないので、以下のコマンドでデータベースをリセットできる。

```sh
rake db:drop
rake db:create
rake db:migrate # devise が利用。
```

`rake db:drop` でデータベースが消えるので、既に稼働しているシステムで上のコマンドを実行してはならない。

- [postgresql - rails db:migrate fails due to duplicate table - Stack Overflow](https://stackoverflow.com/questions/62119399/rails-dbmigrate-fails-due-to-duplicate-table)
- [ruby on rails - Rake aborted... table 'users' already exists - Stack Overflow](https://stackoverflow.com/questions/7874330/rake-aborted-table-users-already-exists)
- [Is there a way to recover a dropped mysql database? - Database Administrators Stack Exchange](https://dba.stackexchange.com/questions/23251/is-there-a-way-to-recover-a-dropped-mysql-database)

## `production.rb` でのメーラー設定
`config/environments/production.rb` でのメーラーの設定は一時的に開発環境 `config/environments/development.rb` と同じものを使っている。

## テストとロケール
以下の `include` を使って文字列をマッチするように書かれた RSpec のテストを例として見ていく。

```ruby
expect(user.errors[:name]).to include('is too long (maximum is 20 characters)')
```

上記のテストは `'is too long (maximum is 20 characters)'` という文字列がエラーメッセージに含まれていることを想定している。しかし、この文字列はロケールが変わると翻訳されるのでテスト失敗となる。

適切に国際化 (internationalization, i18n) された文字列を使うには、まず `config/locales/*.yml` を開いて、文字列のパスを取得する。そして、取得したパスを `I18n.t()` に渡すことでロケールに依存しないテストが書ける。

```
I18n.t('activerecord.errors.models.user.attributes.name.too_long')
```

<!--- 今回は手でパスを取得したが、何らかの工夫をしないとパスの探索でかなりの時間を使うことになる。 (yq?) --->

- [3-2. User モデルのテスト｜Ruby on Rails (7.0) の実践的な開発手法に触れてみよう](https://zenn.dev/tmasuyama1114/books/ab51fea5d5f659/viewer/94919e#%E3%83%90%E3%83%AA%E3%83%87%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AE%E3%83%86%E3%82%B9%E3%83%88%E3%82%92%E8%BF%BD%E5%8A%A0)

## テスト環境のロケールを一時的に上書き
`config/environments/test.rb` に以下の行を追加すると、テスト時のロケールをテスト環境でのみ変更できる。

```
config.i18n.default_locale = :en
```

- [Rails Internationalization (I18n) API — Ruby on Rails Guides](https://guides.rubyonrails.org/i18n.html#translations-for-active-record-models)
