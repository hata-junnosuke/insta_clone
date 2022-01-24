# README

## 内容
- ログイン機能を実装してください。
- その他初期設定を行ってください
  - generateコマンド時に生成されるファイルを制限する
  - ルーティング、JS、CSS、テストが自動生成されないようにする
  - タイムゾーンの設定
- etc

## 補足
- slim-railsを導入してビューテンプレートはslimを使う
- sorceryを導入してログイン機能を実装する
- rubocopを導入してLintチェックを行う
  - .rubocop.ymlは以下をダウンロード・展開したものを使う。ファイル名の先頭に「.」をつけるのを忘れないこと。
  rubocop.yml.zip
  redis-railsを導入してセッションの管理方法をクッキーストアではなくredisにする
- rails-18nを導入して国際化に対応する（メンタリングの都合でモデル名, カラム名のみ国際化対応することとする）
- annotateを導入してモデルが作られるたびに自動的にスキーマ情報がファイルに記載されるようにする
- better_errorsを導入してエラー画面を使いやすくする
- binding_of_callerを導入してエラー画面を使いやすくする
- pry-byebugを導入してデバッグ可能な状態にする
- pry-railsを導入してデバッグ可能な状態にする
- bootstrap material designを導入（gemだとうまく動かないのでyarnで導入）してビューを整える

## 進め方
rails newの段階でgit flow initをしてmasterとdevelopブランチを自身のパブリックリポジトリに対してプッシュすると良いでしょう。
- $ bundle init
- $ Gemfile内の # rails部分のコメントアウトを外し、Railsのバージョンを課題で指定された通りにする。
- $ bundle install --path vendor/bundle
- $ bundle exec rails new . -d mysql --skip-coffee --skip-turbolinks
- gitに上げる前にgitignoreにdatabase.ymlとvendorを追加するといい。
- $ git add .
- $ git commit -m "initial commit"
- $ git flow init (全部EnterでOK。git flowについてはこちらを参照）
- $ git push --all （これでmasterとdevelopが一気にリモートにプッシュされる）
- $ git flow feature start 01_hogehogebranch


## 1/10
- %表記の追加（コロンの削除を忘れずに）
- rubocop追加
- rubocop修正実行（1 offense todoにも残り）
- better_errors
- binding_of_caller
- gem 'pry-byebug'
- gem 'pry-rails'
  - https://pikawaka.com/rails/pry
- gem 'sorcery'
- gem 'slim-rails'
- BMD導入
  - assets/javascript/application.jsを編集
  - stylesheet/application.scssに変更して@import記述
  - package.json記述
  - yarnインストール
- generateコマンド時に生成されるファイルを制限する
- gem 'redis-rails'
  - config/envi/devに記述したがなんのためか不明
- タイムゾーンの設定
  - config/appに記述
- i18nの基本設定
  - config/appに記述
- jqueryとpopperの追加（ブートストラップのため）
- ログイン機能
  - app.scssにcss記述
  - controller/appにフラッシュタイプを記述
  - rails g sorcery:install
  - db/migrate/sorceryを編集
  - bin/rails db:migrate
  - Userモデルにバリデーション追加
  - user_sessions_controller.rb
  - users_controller.rb
  - ja.ymlで日本語化
  - routes.rb
  - viewを作る
  - ここでローカルでやってみたがフラッシュがエラー？ ActionView::MissingTemplate
  - コメントアウトでやると画面は表示される。
    
## 1/11
- 昨日のエラーは解消（なんだったのか、コメントを消したら解決）
- annotaite
  - gem追加
  - bundle exec rails g annotate:install
  - bundle exec annotate
- rubocop
  - bundle exec rubocop -a

## 1/14
- rubocopの修正
- validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }の意味
  - new_record?メソッドは、インスタンスが新規に作成されるものかどうかを判定するActive Recordのメソッド
  - if: ->以下は条件付きバリデーションの、シンボルやLambdasてやProcの部分
- config/envi/dev `config.session_store :redis_store, { servers: 'redis://localhost:6379', expire_after: 1.day }` 
  - rails のセッション管理を redis サーバーで行っている。 
  - expires_afterで有効期限を定めている
  - https://ccbaxy.xyz/blog/2020/06/21/ruby47/