# README

# 08 ユーザーの詳細ページに投稿一覧を表示する

## 内容
ユーザーの詳細ページに同ユーザーの投稿を一覧表示させてください。

## 補足
- タイル表示させる
- ヘッダーのユーザーアイコンに自分のユーザー詳細ページへのリンクを設定してさせる

## 開発メモ
### 1/27
- ヘッダーの画像から詳細画面へのリンク
- 詳細画面で投稿一覧見れるように
- 詳細に投稿の画像表示して投稿の詳細リンクをつける
- SCSS編集

## 学習ポイント
- なぜ`thumbnail_post.images.first.url`なのか
  - https://tech-essentials.work/questions/143
  - ><%= render partial: 'fuga', collection: @hoges %>の場合、ローカル変数として使われるのはhogeではなくfugaです。
  なので、<%= render @hoges %>の場合にview側でhogeと書けるのも、@hogesの単数系だからではありません。
パーシャル名がhogeだから、ローカル変数がhogeとなるんです。
  - ここを勘違いしていた。collectionで変数を決めていると思っていた。
  - ではcollectionは何をしている？
    - コレクションとしてどんな情報（配列っぽいもの）を渡してやるかをcollection:オプションで指定してやります。
    - ってことはthumbnail_postという変数には@user.postsの情報が入っているということ。

- bootstrapの.col-md-10.offset-md-1
  - 今更だがoffsetで余白を作っていたと理解
- 画像でのリンクの貼り方
```bigquery
= link_to post_path(thumbnail_post), class: 'thumbs' do #ここでリンク先を指定
    = image_tag thumbnail_post.images.first.url #ここでリンクを貼る画像を指定
```