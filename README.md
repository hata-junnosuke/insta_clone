# README

# 10 通知機能の実装

## 内容
- 通知機能を実装してください。
- タイミングと文言は以下の通りとします。（リンク）と書いてある箇所はリンクを付与してください。
  - フォローされたとき
    - xxx（リンク）があなたをフォローしました
    - 通知そのものに対してはxxxへのリンクを張る
  - 自分の投稿にいいねがあったとき
    - xxx（リンク）があなたの投稿（リンク）にいいねしました
    - 通知そのものに対しては投稿へのリンクを張る
  - 自分の投稿にコメントがあったとき
    - xxx（リンク）があなたの投稿（リンク）にコメント（リンク）しました
    - 通知そのものに対してはコメントへのリンクを張る（厳密には投稿ページに遷移し当該コメント部分にページ内ジャンプするイメージ）
- 既読判定も行ってください。通知一覧において、既読のものは薄暗い背景で、未読のものは白い背景で表示しましょう。
- 既読とするタイミングは各通知そのものをクリックした時とします。
- 不自然ではありますが通知の元となったリソースが削除された際には通知自体も削除する仕様とします。

## 補足
- ポリモーフィック関連を使うこと
- ヘッダー部分の通知リストには最新の10件しか表示させないこと

# 開発メモ
## 予習ポイント
解答例のコードから初めて見るものを事前学習をする。
- 通知機能はどう実装する？
  >https://qiita.com/ytoo14/items/2db1dd4fcd7945b980f7 (実装形式は違うが参考までに)
- ポリモーフィック関連とは？
  - ポリモーフィック関連付けを使うと、ある1つのモデルが他の複数のモデルに属していることを、1つの関連付けだけで表現できます。
  - 今回で当てはめるとActivityモデルを複数のモデルに関連づけている。
  >https://railsguides.jp/association_basics.html#%E3%83%9D%E3%83%AA%E3%83%A2%E3%83%BC%E3%83%95%E3%82%A3%E3%83%83%E3%82%AF%E9%96%A2%E9%80%A3%E4%BB%98%E3%81%91
- `enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }`
  - これはaction_typeを定義している。（○○なら1みたいに）
- `after_create_commit :create_activities`
  - コールバック関数
  - after_create_commitはcreateをすると指定したアクションが発動することを表す
  > https://railsguides.jp/active_record_callbacks.html#:~:text=%E5%AE%A3%E8%A8%80%E3%81%A7%E3%81%8D%E3%81%BE%E3%81%99%E3%80%82-,10%20%E3%83%88%E3%83%A9%E3%83%B3%E3%82%B6%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AE%E3%82%B3%E3%83%BC%E3%83%AB%E3%83%90%E3%83%83%E3%82%AF,-%E3%83%87%E3%83%BC%E3%82%BF%E3%83%99%E3%83%BC%E3%82%B9%E3%81%AE%E3%83%88%E3%83%A9%E3%83%B3%E3%82%B6%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3
- gem 'letter_opener_web'(このgemは最終的にはこの課題では導入されていない)
  - letter_openerに送信された電子メールを閲覧するためのインターフェースを提供します。(とりあえずメールに関するgemと理解)
  >https://qiita.com/tanutanu/items/c6193c4c2c352ac152ec

## 通知機能実装
- ### モデル作成
1. `$ bundle exec rails g model activity subject:references user:references action:integer read:boolean`
2. マイグレーションファイル編集
```bigquery
class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.references :subject, polymorphic: true
      t.references :user, foreign_key: true
      t.integer :action_type, null: false
      t.boolean :read, null: false, default: false

      t.timestamps
    end
  end
end
```
3. `bundle exec rails db:migrate`
   作成されるテーブル
```
create_table "activities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "subject_type" #コメントなのか、いいねなのか、フォローなのかを判別
    t.bigint "subject_id"　#上で判別したもののidを入れる
    t.bigint "user_id"　#通知の送信先
    t.integer "action_type", null: false　#subject_typeと同じ？(integer型のことに注意)
    t.boolean "read", default: false, null: false　#既読を管理のために使う
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_type", "subject_id"], name: "index_activities_on_subject_type_and_subject_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end
```


4. モデルの関連づけ
- まずはactivityモデルとuserモデルを関連づける（userは複数の通知を持つ）
- そしてcomment,like,relationshipモデルへポリモーフィック関連
  - この際`has_one`で関連づける。（例えばコメント1つにつき、1つの通知を送るため）
- コールバック関数でアクションの発動タイミングを設定
  - 今回ではコメント、いいね、フォローがcreateされた後にactivity(通知)が作られるようにする。
    activity.rb
```
class Activity < ApplicationRecord
  # ポリモーフィック関連
  belongs_to :subject, polymorphic: true
  belongs_to :user

  # ここでaction_typeを数字に変換（コメントに対してなら0みたいな）
  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }
end

```
user.rb
```
has_many :activities, dependent: :destroy #これを追記
```
comment.rb(他のモデルは省略)
```
#以下を追記
has_one :activity, as: :subject, dependent: :destroy

#createが発生したアクションが発動
  after_create_commit :create_activities

  private

  def create_activities
    Activity.create(subject: self, user: post.user, action_type: :commented_to_own_post)
  end
```
簡単に表にすると
[![Image from Gyazo](https://i.gyazo.com/3ee3e53307b84cab3e1c83fe225af6af.png)](https://gyazo.com/3ee3e53307b84cab3e1c83fe225af6af)

- ### ルーティング
```
resources :activities, only: [] do #only: []でresourcesのアクション全て使用しないことを明記している。
    #readアクションを追加
    #patchは戻せないアクションと理解。今回で言えば一度read（既読）すると2度と未読にはならない。
    patch :read, on: :member
end

namespace :mypage do
  resource :account, only: %i[edit update]
  #mypageでも通知機能を使えるように設定
  resources :activities, only: %i[index]
end
```

- ### ビューの作成
#### shared/_header_activities.html.slim
これはハートマークの設定
これをクリックするとドロップダウン（_header_activities.html.slim）で通知が見られるようにする
また後に作成するがshared/unread_badgeは未読通知の数をハートの上に表記するもの
```
li.nav-item
  .dropdown
    a#dropdownMenuButton.nav-link.position-relative href="#" data-toggle="dropdown" aria-expanded="false" aria-haspopup="true"
      = icon 'far', 'heart', class: 'fa-lg'
      = render 'shared/unread_badge'
    #header-activities.dropdown-menu.dropdown-menu-right.m-0.p-0 aria-labelledby="dropdownMenuButton"
      = render 'shared/header_activities'
```
#### _header_activities.html.slim
これはハートからドロップダウンでの通知のビュー
activity.action_typeで分岐させてコメントならコメントに対応したビュー（_commented_to_own_post.html.slim）へ遷移させる（いいね、フォローも同様）
```
- if current_user.activities.present?
    - current_user.activities.recent(10).each do |activity|
        /activity.action_typeで分岐させてコメントならコメントに対応したビュー（_commented_to_own_post.html.slim）へ遷移させる
        = render "shared/#{activity.action_type}", activity: activity
    - if current_user.activities.count > 10
        = link_to 'すべてみる', mypage_activities_path, class: 'dropdown-item justify-content-center'
- else
    .dropdown-item
        | お知らせはありません
```
#### _commented_to_own_post.html.slim（likesとrelationshipは省略するが同様に作成）
コメントをされたことを通知するビュー

`#{'read' if activity.read?}"`でクラスをreadとすることで既読ならcssで暗く表示されるようにする
```
= link_to read_activity_path(activity), class: "dropdown-item border-bottom #{'read' if activity.read?}", method: :patch do
  = image_tag activity.subject.user.avatar.url, class: 'rounded-circle mr-1', size: '30x30'
  object
    = link_to activity.subject.user.username, user_path(activity.subject.user)
  | があなたの
  object
    = link_to '投稿', post_path(activity.subject.post)
  | に
  object
    = link_to 'コメント', post_path(activity.subject.post, anchor: "comment-#{activity.subject.id}")
  | しました
  .ml-auto
  　　　/時間の記述
    = l activity.created_at, format: :short
```
#### _unread_badge.html.slim
ヘッダーのハートの上に表示するバッチで通知の未読数を表す
 ```
 - if current_user.activities.unread.count > 0
  span.badge.badge-warning.navbar-badge.position-absolute style='top: 0; right:0;'
    = current_user.activities.unread.count
 ```
unreadメソッドはactivity.rbで
`enum read: { unread: false, read: true }`
と記述することで使えるようになる。

#### activities_controller.rb
readメソッドを使うために作成
 ```
 class ActivitiesController < ApplicationController
  before_action :require_login, only: %i[read]

  def read
    activity = current_user.activities.find(params[:id])
    # 未読を既読に変える
    activity.read! if activity.unread?
    # リダイレクトメソッドはactivity.rbに追記
    redirect_to activity.redirect_path
  end
 end
 ```
 ```
 #activity.rb
 #クリックしたリンク先を指定
 def redirect_path
    case action_type.to_sym
    when :commented_to_own_post
      post_path(subject.post, anchor: "comment-#{subject.id}")
    when :liked_to_own_post
      post_path(subject.post)
    when :followed_me
      user_path(subject.follower)
    end
  end
 ```
**マイページでの実装は構造が似ているので省略**

### cssとja.yml
解答例で確認

## 確認してみよう
### ログで確認してみると、コメントしたらActivityが作成されていることを確認！
1. コメントがcreate
2. after_create_commitで:create_activitiesが発動してActivityがcreate
   [![Image from Gyazo](https://i.gyazo.com/10f08ff0f906fdda89e8c702fa7a2bd7.png)](https://gyazo.com/10f08ff0f906fdda89e8c702fa7a2bd7)

### 実際の画面はどうなっているだろうか。
1. AからBをフォローした。
2. ヘッダーに通知があることを知らせるバッチとBのマイページの通知一覧に表示されている。
   [![Image from Gyazo](https://i.gyazo.com/c0c117b5c165b3bd6de00cc208852b3b.png)](https://gyazo.com/c0c117b5c165b3bd6de00cc208852b3b)
3. その通知からフォローしてくれたユーザーのページへ遷移することを確認
4. 戻って既読になったので通知が暗くなっていることとバッチが消えていることを確認
   [![Image from Gyazo](https://i.gyazo.com/ae23d959407c3c8e6b059b6dd5011f64.png)](https://gyazo.com/ae23d959407c3c8e6b059b6dd5011f64)

## コメント
- 通知機能は複数のモデルと結びついていて頭の整理に時間がかかってしまいました。
- Activityモデルのaction_typeってsubject_typeと型が違うのは分かるのですがあとはどう言う違いがあるのか良くわからなかったです。
- 実は問題点が2つあります。これは課題提出後、原因を探ってみます。（ここで詰まって止まるより通知機能の考察をすることが重要と考えたため判断しました。）
  - ヘッダーのハートを押してもドロップダウンが表示されない。
  - いいねしたことを通知する際にobjectが表示できていない。

