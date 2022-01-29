# README

# 10 通知機能の実装

## 内容
- 通知機能を実装してください。
- タイミングと文言は以下の通りとします。（リンク）と書いてある箇所はリンクを付与してください。   
  -フォローされたとき
  -xxx（リンク）があなたをフォローしました
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
### 0. 予習ポイント
解答例のコードから初めて見るものを事前学習をする。
- 通知機能はどう実装する？
  >https://qiita.com/ytoo14/items/2db1dd4fcd7945b980f7 (実装形式は違うが参考までに)
- ポリモーフィック関連とは？
  - ポリモーフィック関連付けを使うと、ある1つのモデルが他の複数のモデルに属していることを、1つの関連付けだけで表現できます。
  >https://railsguides.jp/association_basics.html#%E3%83%9D%E3%83%AA%E3%83%A2%E3%83%BC%E3%83%95%E3%82%A3%E3%83%83%E3%82%AF%E9%96%A2%E9%80%A3%E4%BB%98%E3%81%91
- `enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }`
  - これはaction_typeを定義している。（○○なら1みたいに）
- `after_create_commit :create_activities`
  - after_create_commitはcreateをすると指定したアクションが発動することを表す
  > https://railsguides.jp/active_record_callbacks.html#:~:text=%E5%AE%A3%E8%A8%80%E3%81%A7%E3%81%8D%E3%81%BE%E3%81%99%E3%80%82-,10%20%E3%83%88%E3%83%A9%E3%83%B3%E3%82%B6%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AE%E3%82%B3%E3%83%BC%E3%83%AB%E3%83%90%E3%83%83%E3%82%AF,-%E3%83%87%E3%83%BC%E3%82%BF%E3%83%99%E3%83%BC%E3%82%B9%E3%81%AE%E3%83%88%E3%83%A9%E3%83%B3%E3%82%B6%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3
- gem 'letter_opener_web'(このgemは最終的にはこの課題では導入されていない)
  - letter_openerに送信された電子メールを閲覧するためのインターフェースを提供します。(とりあえずメールに関するgemと理解)
  >https://qiita.com/tanutanu/items/c6193c4c2c352ac152ec
- 既読管理
  - `@import 'header';`// ヘッダー用のscssを取り込みます。
### 1. 通知機能実装
#### モデル作成
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
4. モデルの関連づけ
activity.rb
```bigquery
class Activity < ApplicationRecord
  # ポリモーフィック関連
  belongs_to :subject, polymorphic: true
  belongs_to :user

  # ここでaction_typeを数字に変換（コメントに対してなら0みたいな）
  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }
end

```
user.rb
```bigquery
has_many :activities, dependent: :destroy #これを追記
```
comment.rb(他のモデルは省略)
```bigquery
#以下を追記
#createが発生したアクションが発動
  after_create_commit :create_activities

  private

  def create_activities
    Activity.create(subject: self, user: post.user, action_type: :commented_to_own_post)
  end
```

#### ビューの作成
解答例で確認

#### cssとja.yml
解答例で確認


### 2. 既読管理

### 考察
- create_activityのなかみ
- 