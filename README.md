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
  - config/envi/deveに記述したがなんのためか不明

## TODO
- rubocop修正
- config/envi/deveに記述したがなんのためか不明なので調べる
  - https://ccbaxy.xyz/blog/2020/06/21/ruby47/
- 