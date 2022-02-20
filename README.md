# README

## 内容
- 投稿のページネーションを実装してください

## 補足
- ページネーションにはkaminariを使用する
- 1ページあたり15件とする
- ページネーションにもbootstrapを適用する

## 開発メモ
###1/22
- git flow
  - `git flow feature start 03_pagenation`（事前にこれまでのものをpushしておく）
  - `git pull origin feature/02_crud`
- kaminari
  - https://github.com/kaminari/kaminari
  - ポストコントローラー
  - `bundle exec rails g kaminari:views bootstrap4 -e slim`
  - `rails g kaminari:config`
  - config/ini/kaminari~作成（10件になっているのを15に）



