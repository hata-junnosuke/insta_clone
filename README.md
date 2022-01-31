# README

# 11 メール通知

## 内容
メール通知機能を実装してください。
タイミングと文言は以下の通りとします。
- フォローされたとき
- 自分の投稿にいいねがあったとき
- 自分の投稿にコメントがあったとき

## 補足
- default_url_optionsの設定値はconfigというgemを使い定数として設定すること
- 今後定数に関してはconfigを使う方針とする
  ![image](https://user-images.githubusercontent.com/81806676/151790079-637af031-2d91-4327-835b-ed0c79eb4b3a.png)



# 予習
## gem configとは
- 一言で言えば**定数を管理するgem**
- **環境ごとに違う定数を用いたい**または**いろいろなところに散らばる定数をまとめたい**ときにconfigを使うといいらしい。
- 使い方については以下を参照
>https://github.com/rubyconfig/config
>
>https://qiita.com/tanutanu/items/8d3b06d0d42af114a383
## gem letter_opener_webとは
- letter_openerに送信された電子メールを閲覧するためのインターフェースを提供します。
- 使い方については以下を参照
>https://github.com/fgrehm/letter_opener_web
>
>https://qiita.com/tanutanu/items/c6193c4c2c352ac152ec

# 実装
## gemのインストール
- gem config
- gem letter_opener_web<br>
  以上をgemfileに記述して`bundle install`

## configの設定
1. `bundle exec rails g config:install`
- 各ファイルが作成される。<br>
  [![Image from Gyazo](https://i.gyazo.com/55927efde24dbbac64236f83b6ff761e.png)](https://gyazo.com/55927efde24dbbac64236f83b6ff761e)
- .gitignoreに追記される
```
#localで使うものはgithubに上げないように
config/settings.local.yml
config/settings/*.local.yml
config/environments/*.local.yml
```
- config/initializers/config.rb
  設定が定義される。<br>
  `config.const_name = 'Settings'`
- ymlファイルは空ファイル

## メールの設定
1. `$ bundle exec rails generate mailer UserMailer`
   [![Image from Gyazo](https://i.gyazo.com/45664c13f1db10e10f518c9c95d20607.png)](https://gyazo.com/45664c13f1db10e10f518c9c95d20607)
2. メール受信の設定を定数として設定
```
#config/environments/development.rb
  #以下を追記
  # アプリケーションのホスト情報をメイラー内で使うためのオプション
  config.action_mailer.default_url_options = Settings.default_url_options.to_h
  # 配信方法を指定
  config.action_mailer.delivery_method = :letter_opener_web
end
```
```
#config/settings/development.yml

#setting.default_url_optionsとするとhost: 'localhost:3000'を取得できる
default_url_options:
  host: 'localhost:3000'
```
3. メールの実装
- メールに関するアクションを設定（いいねとフォローについては省略）
```
#app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def comment_post
  　　　　# コメントを受けたユーザー
    @user_from = params[:user_from]
    # コメントをしたユーザー
    @user_to = params[:user_to]
    @comment = params[:comment]
    #コメントを受けたことを通知するメールを設定
    mail(to: @user_to.email, subject: "#{@user_from.username}があなたの投稿にいいねしました")
  end
end
```
- コメントされた時にメールで通知する設定（いいねとフォローについては省略）
```
#app/controllers/comments_controller.rb
def create
    @comment = current_user.comments.build(comment_params)
    #@comment.saveから変更
    #コメントがsaveされたら受け手に対してメールを送信する。
    UserMailer.with(user_from: current_user, user_to: @comment.post.user, comment: @comment).comment_post.deliver_later if @comment.save
end
```

- デフォルトの送信元を設定
```
#app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: 'instaclone@example.com'
  layout 'mailer'
end
```
- ビューの作成　（いいねとフォローについては省略）
```
#app/views/user_mailer/comment_post.html.slim
#メールの本文
h2 = "#{@user_to.username}さん"
p = "#{@user_from.username}さんがあなたの投稿にコメントしました。"
= link_to "確認する", post_url(@comment.post, { anchor: "comment-#{@comment.id}" })
```
- ルーティング
```
#公式で設定することが記述
if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
end
```

## 確認してみよう。
1. コメントをする
   [![Image from Gyazo](https://i.gyazo.com/3d352af6dbc9f4a7e2a1d54bab24830b.png)](https://gyazo.com/3d352af6dbc9f4a7e2a1d54bab24830b)
2. ログを見る
- **送れている模様！**
  [![Image from Gyazo](https://i.gyazo.com/38be9e8af75396fb060759949ebe4aa9.png)](https://gyazo.com/38be9e8af75396fb060759949ebe4aa9)
3. http://localhost:3000/letter_opener/　で確認
- **できていた！**
  [![Image from Gyazo](https://i.gyazo.com/03cc88a519f7565dc2b2685a125c1153.png)](https://gyazo.com/03cc88a519f7565dc2b2685a125c1153)


## コメント
- 今回の実装はこれまでよりも比較的理解しながら進められた感覚があります。
- configを使う場面は規模が大きくなると整理するために必要なのかなと思いました。ただ正直なくてもいいかなとも思いました。
- 段々、前回の通知でもそうでしたがスパルタコースのホームページでも使われている技術を吸収できている気がしてます。実際に使える技術を修得できてきている気がします。
- あと、解答例でコメントがあったことを伝えるメールでタイトルが「あなたの投稿にいいねしました」になってしまっています。
