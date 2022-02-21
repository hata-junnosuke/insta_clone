# README

# 09 プロフィール編集機能


## 内容
プロフィールの編集機能を実装してください

## 補足
- 編集画面は/mypage/account/editというパスとする
- アバターとユーザー名を変更できるようにする
- アバター選択時（ファイル選択時）にプレビューを表示する
- image_magickを使用して、画像は横幅or縦幅が最大400pxとなるようにリサイズする
- 以降の課題でもマイページに諸々追加するのでそれを考慮した設計とする（ルーティングやコントローラやレイアウトファイルなど）
## 開発メモ
## 1. まずはUserモデルにアバター用のカラムを追加する
    - ` bundle exec rails g migration AddAvatarToUsers`
    - マイグレーションファイルを変更
    ```
    #  db/migrate/20220127042444_add_avatar_to_users.rb
      class AddAvatarToUsers < ActiveRecord::Migration[5.2]
        def change
          add_column :users, :avatar, :string
        end 
      end
    ```
    - `bundle exec rails db:migrate`

## 2. 編集画面は/mypage/account/editというパスとする
- routes.rb

    namespace :mypage do
        resource :account, only: %i[edit update]
    end
>ルーティングについてはこちらを参考にする
>https://tech-essentials.work/movies/1

### なぜnamespace :mypageを使うのか
- users_controllerでeditを設定すればいいのではないかと思った。
- https://github.com/miketa-webprgr/TIL/blob/master/11_Rails_Intensive_Training/09_issue_note.md
>mypageディレクトリ以下にコントローラファイルやビューファイルが保存されるようになる。
>管理者画面を実装する場合、「管理者であれば〜を表示したい」ということや、
>「管理者であれば〜という機能を実装したい」などということが多いかと思う。
>そのような場合、ディレクトリを分けることなく、if文などを使って対応することもできるが、
namespaceを使って、ディレクトリを分ける方がスマートである。

とのこと。
## 3. 画像のセッティング（carrierwave）
公式　https://github.com/carrierwaveuploader/carrierwave#getting-started
1. `rails generate uploader Avatar`
2. app/uploaders/avatar_uploader.rbが作成される
3. avatar_uploader.rbの設定を行う（基本的には、コメントアウトを戻す・修正する形で行える）
4. Carrierwaveが使えるように、User.rbファイルに追記を行う

      #user.rb
      # 画像セットのため追記
      mount_uploader :avatar, AvatarUploader 
## 4. プロフィール編集画面の実装
### コントローラー
- 編集画面しか実装しないので、editアクションとupdateアクションの設定
- `.permit(:email, :username, :avatar, :avatar_cache)`について、編集画面では`:username`と`:avatar`のみでいいが、今後を見据えて他のものも入っていると思われる。

```
#mypage/accounts_controller.rb
class Mypage::AccountsController < Mypage::BaseController
  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(account_params)
      redirect_to edit_mypage_account_path, success: 'プロフィールを更新しました'
    else
      flash.now['danger'] = 'プロフィールの更新に失敗しました'
      render :edit
    end
  end

  private

  def account_params
    params.require(:user).permit(:email, :username, :avatar, :avatar_cache)
  end
end
```
### mypage/base_controller.rbの設定
- いわば、mypage版のapplication_controller.rbと思ってもいい。（と思う。）
```
class Mypage::BaseController < ApplicationController
  before_action :require_login
  layout 'mypage'
end
```
### ビューの実装
- application.html.slimのような立ち位置でlayout/mypage.html.slimを作成
```
/layouts/mypage.html.slim

doctype html
html
  head
    meta content=("text/html; charset=UTF-8") http-equiv="Content-Type" /
    meta[name="viewport" content="width=device-width, initial-scale=1.0"]
    title マイページ | InstaCloneApp
    = csrf_meta_tags
    = csp_meta_tag
    = stylesheet_link_tag 'mypage', media: 'all'
    = javascript_include_tag 'mypage'
  body
    = render 'shared/header'
    = render 'shared/flash_messages'
    main
      .container
        .row
          .col-md-8.offset-md-2
            .card
              .card-body
                .row
                  .col-md-3
                    = render 'mypage/shared/sidebar'　　#この後作成
                  .col-md-9
                    .mypage_content
                      = yield　　　　#これでedit.html.slimを入れて表示させる
```
- mypage/shared/sidebarを作成
- edit.html.slimを作成

### プレビューの実装
- assets/javascripts/mypage.jsにおいてJavascriptでFileAPIっていうのを使っているらしい。
> [JavaScript FileAPIについて学ぶ \- Qiita](https://qiita.com/kodokunadancer/items/8028d87d8d2bc6c00e69)
- ちょっとここは後回しにして理解しようと思います。

## 5. 細かい修正
- locales/ja.ymlに追加(avatar: 'アバター)
- 自分のページであれば編集ページへのリンクを表示
- デフォルト画像のところを編集
- ユーザー一覧の上を編集画面のリンクへ
- &.で未ログイン時に編集画面に行ったときのエラー発生を防ぐ
    - `if current_user&.id == @user.id`
-  rubocop

## コメント
- /mypage/account/editを使うメリットはスマートということ以外にeditのviewにいくURLにidが含まれないこと（セキュリティー面）なのかなと思いました。
- mypage/account_controllerは一気に作れないのでしょうか。（rails g controllerのように）
- FileAPIについては理解に時間がかかりそうなので後回しで先に進もうと思います。
- みけたさんのノートを参考に理解させていただきました。ありがとうございました。
>参考
>https://github.com/miketa-webprgr/TIL/blob/master/11_Rails_Intensive_Training/09_issue_note.md