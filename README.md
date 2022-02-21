# README

# 14 SEO対策 メタタグの設定

# 内容
- SEO対策として必須であるメタタグの設定をしましょう
- gem 'meta-tags'で実装しましょう。

# 補足
- title, description, keywordが適切に設定されるようにしましょう。
- ngrokを使うと一時的にインターネット上にサイトを公開できるのでSlackに投稿した時にメタタグが本当に反映されているか確認できます。

# 予習
## SEOとは
- SEOとは、検索エンジンを使ったマーケティング戦略のひとつです。Googleなどの自然検索結果で自社のページが表示されることにより、サービスや商品を知らないユーザーがページを見て検討する機会を創出します。
>https://www.irep.co.jp/knowledge/blog/detail/id=45926/

## メタタグとは？
- metaタグとは記事コンテンツの情報を検索エンジンやブラウザに伝えるための情報です。
>https://ferret-plus.com/13074

- gem 'meta-tags'
>https://github.com/kpumuk/meta-tags
> 
> http://vdeep.net/rubyonrails-meta-tags-seo

## ngrokとは？
- 簡単にいうと、ローカルPC上で稼働しているネットワーク（TCP）サービスを外部公開できるサービスです。例えば、ローカルPCのWebサーバを外部公開することができます。
>https://qiita.com/mininobu/items/b45dbc70faedf30f484e

# 実装
## gemのインストール
gem 'meta-tags'

## `$ bundle exec rails generate meta_tags:install`
- config/initializers/meta_tags.rbが作成される
- デフォルトでOK

## 設定を記述
```
# app/helpers/application_helper.rb

module ApplicationHelper
  def default_meta_tags
    {
      # サイト名
      site: Settings.meta.site,
      # trueを設定することで「タイトル | サイト名」の並びで出力してくれる
      reverse: true,
      # タイトルを設定
      title: Settings.meta.title,
      # descriptionを設定
      description: Settings.meta.description,
      # キーワードを「,」区切りで設定
      keywords: Settings.meta.keywords,
      # canonicalタグを設定
      canonical: request.original_url,
      # オープングラフ
      og: {
        title: :full_title,
        type: Settings.meta.og.type,
        url: request.original_url,
        image: image_url(Settings.meta.og.image_path),
        site_name: :site,
        description: :description,
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image'
      }
    }
  end
end

```

```bigquery
# application.html.slim
# タイトル表示
= display_meta_tags(default_meta_tags)
```

```bigquery
# user_sessions/new.html.slim

# 先頭に追記することでタグでのタイトルを設定
- set_meta_tags title: 'ログインページ'

```
```bigquery
# config/settings.yml

# 追記（定数を設定）
meta:
  site: InstaClone
  title: InstaClone - Railsの実践的アプリケーション
  description: Ruby on Railsの実践的な課題です。Sidekiqを使った非同期処理やトランザクションを利用した課金処理など実践的な内容が学べます。
  keywords:
    - Rails
    - InstaClone
    - Rails特訓コース
  og:
    type: website
    image_path: ogp.png
```


## 確認してみよう
- タグはうまく表示されている！
[![Image from Gyazo](https://i.gyazo.com/cd8759262123765b0cefe953a33b936d.png)](https://gyazo.com/cd8759262123765b0cefe953a33b936d)

## コメント
- SEOなど初めて聞いた言葉で現場感が出てきた感じがします。
- SEO対策などを通じてサービスでいかに顧客を掴むかを戦略を練るのですね。
- ただ、ngrokの使い方が正しくないようで確認できていません。ヒントをいただけるとありがたいです。
## ngrok
ここがうまくできませんでした。
ngrokをダウンロードをしてトークンも入力して<br>
`$ ./ngrok http 80`をやってみたのですが、 http://localhost:80にs接続が拒否されてしまいます。
[![Image from Gyazo](https://i.gyazo.com/b903e7ef1fc4f36990bf22ac70ef1555.png)](https://gyazo.com/b903e7ef1fc4f36990bf22ac70ef1555)
[![Image from Gyazo](https://i.gyazo.com/00c9f233596b72ded40614529ef068da.png)](https://gyazo.com/00c9f233596b72ded40614529ef068da)
- うまくできていればこのようになると思われるのですが、、
[![Image from Gyazo](https://i.gyazo.com/4f572799c7f1e0769c3a4727bb3a1533.png)](https://gyazo.com/4f572799c7f1e0769c3a4727bb3a1533)

## 追記
- ご指摘からやり方が違ったことが判明
1. `./ngrok http 3000`
2. こちらのURLでアクセスすると閲覧できた。
[![Image from Gyazo](https://i.gyazo.com/c28ae8dcda7d6cf15af0a60190efb4ec.png)](https://gyazo.com/c28ae8dcda7d6cf15af0a60190efb4ec)
3. slackにURLを貼り付けると出現
[![Image from Gyazo](https://i.gyazo.com/ee9e1ac76a498871341d6ef3ba06e05a.png)](https://gyazo.com/ee9e1ac76a498871341d6ef3ba06e05a)