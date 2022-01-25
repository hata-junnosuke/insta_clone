# README

## 内容
投稿に対するいいね機能を実装してください

## 補足
- link_toを使って非同期処理として実装する
- like, unlike, like?メソッドをユーザーモデルに実装してそれを利用する形にする
- Likeモデルに適切なバリデーションを付与する

## 開発メモ
### 1/24
- まずはいいね機能の実装方法を確認
  - https://techtechmedia.com/favorite-function-rails/
- `has_many :like_users, through: :likes, source: :user`これはどゆこと
  - https://qiita.com/tanutanu/items/2a27f1e503c4cbf30928
  - 別名のカラムを作成して中間テーブルの役割をしている
- `bundle exec rails g model like user:references post:references`
- t.index [:user_id, :post_id], unique: trueでダブり防止
- `bundle exec rails db:migrate`
- likeモデルでもバリデーション
- userとpostに関連づけとメソッド追加
-  bundle exec rails g controller likes
- view作成
- routes
