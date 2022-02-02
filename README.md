# README

# 13 通知の設定を実装

# 内容
通知をするかしないかをユーザーが設定できる機能を実装してください。

# 補足
- マイページに通知設定というメニューを追加してください
- コメント時の通知メール, いいね時の通知メール, フォロー時の通知メールのオンオフを切り替えられるようにしてください


# 実装
今回は早速実装にかかる。

## カラムを追加する。
1. `$ bundle exec rails g migration AddNotificationFlagsToUsers`
2. マイグレーションファイルをいじる
```bigquery
class AddNotificationFlagsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notification_on_comment, :boolean, default: true
    add_column :users, :notification_on_like, :boolean, default: true
    add_column :users, :notification_on_follow, :boolean, default: true
  end
end
```
3. `$ bundle exec rails db:migrate`

## 通知設定の実装
1. マイページで通知設定をするためのコントローラーを作成($ bundle exec rails g controller mypage::notification_settings)
```bigquery
class Mypage::NotificationSettingsController < Mypage::BaseController
  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(notification_settings_params)
      redirect_to edit_mypage_notification_setting_path, success: '設定を更新しました'
    else
      flas.now[:danger] = "設定の更新に失敗しました"
      render :edit
    end
  end

  private

  def notification_settings_params
    params.require(:user).permit(:notification_on_comment, :notification_on_like, :notification_on_follow)
  end
end
```
2. ルーティング
```bigquery
#routes.rb

namespace :mypage do
    resource :account, only: %i[edit update]
    resources :activities, only: %i[index]
    #ここを追記
    resource :notification_setting, only: %i[edit update]
  end
```
3. ビューの作成
```bigquery
#edit.html.slim

= form_with model: @user, url: mypage_notification_setting_path, method: :patch, local: true do |f|
  = render 'shared/error_messages', object: f.object
  .form-group
    = f.check_box :notification_on_comment
    = f.label :notification_on_comment

  .form-group
    = f.check_box :notification_on_like
    = f.label :notification_on_like

  .form-group
    = f.check_box :notification_on_follow
    = f.label :notification_on_follow

  = f.submit class: 'btn btn-primary btn-raised'
```
```bigquery
#_sidebar.html.slim

li
  = link_to '通知設定', edit_mypage_notification_setting_path
  hr
```
4. ja.ymlの設定
```
#ja.yml

#追記
notification_on_comment: 'コメント時の通知メール'
notification_on_like: 'いいね時の通知メール'
notification_on_follow: 'フォロー時の通知メール'
```

## ロジック実装
各コントローラーにチェックがtrueならば通知メールを送るようにする。(likes,relationshipsは省略)
```bigquery
# comments_controller.rb

def create
    @comment = current_user.comments.build(comment_params)
    #コメントがsaveされたら受け手に対してメールを送信する。
    #&&以降を追記
    UserMailer.with(user_from: current_user, user_to: @comment.post.user, comment: @comment).comment_post.deliver_later if @comment.save&& @comment.post.user.notification_on_comment?
  end
```

# 確認してみよう
1. コメント通知をしないようにテェックを外す
[![Image from Gyazo](https://i.gyazo.com/94271e67c4cce34117d074145b795610.png)](https://gyazo.com/94271e67c4cce34117d074145b795610)
2. アカウントを変えてコメントをする
3. 元のアカウントへ再度ログインしてメールが届いているのか確認(http://localhost:3000/letter_opener/)
- **届いていない！(この画面だけでは判断は私にしかできませんが)**
   [![Image from Gyazo](https://i.gyazo.com/80a0fa730ecf6751f4ef27a3dd64211d.png)](https://gyazo.com/80a0fa730ecf6751f4ef27a3dd64211d)
4. 通知を許可しているアカウントへコメントをしてみるとメールが送れている事を確認
- **送れているので、設定がうまくいっている事を確認**   
[![Image from Gyazo](https://i.gyazo.com/69d82d5e49249da4777bff09129a84ac.png)](https://gyazo.com/69d82d5e49249da4777bff09129a84ac)

# コメント
- 今回はシンプルにMVCを作り上げるのみだったので理解しやすかったです。
- ですが、通知を設定できることはユーザー目線で価値あるものであると思うので重要な課題であったと思います。