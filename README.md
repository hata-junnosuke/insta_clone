# README

# 06 フォロー機能を実装

## 内容
フォロー機能を実装してください

## 補足
- フォロー・アンフォローは非同期で行う。form_withを利用すること。
- 適切なバリデーションを付与する
- 投稿一覧画面について
- ログインしている場合
  - フォローしているユーザーと自分の投稿だけ表示させること
- ログインしていない場合
  - 全ての投稿を表示させること
- 一件もない場合は『投稿がありません』と画面に表示させること
- 投稿一覧画面右にあるユーザー一覧については登録日が新しい順に5件分表示してください
- ユーザー一覧画面、詳細画面も実装すること

## 開発メモ
### 1/25
- フォロー機能の実装方法を記事で学習
  - https://qiita.com/nakachan1994/items/e6107fe3003f6515e385
  - https://qiita.com/mitsumitsu1128/items/e41e2ff37f143db81897
- user一覧と詳細
  - `render @user`ってドユコト
- post一覧編集
- relationshipモデル作成
  - 関連づけ
    - # :userじゃないの？Userモデルの中間テーブルになるため、どちらもユーザーのidが入るので、わかりやすいように、あえてuser_idを使っていない。
      belongs_to :follower, class_name: 'User'
      belongs_to :followed, class_name: 'User'
    
- userモデルと関連づけ
- relationshipコントローラ作成
- relationshipビュー作成
- routes

### 1/26
- 考察
  - has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    - https://www.youtube.com/watch?v=gATeEnr8gh4
      - 上はフォローしている人をactiveを通じてfollowed(フォローされている人)から持ってくる。
      - 下はフォロワーをpassiveを通じてfollower(フォローしている人)持ってくる。
  - ` Post.where(user_id: following_ids << id)`なぜこれで自分の投稿まで取得できる？
    - https://qiita.com/miketa_webprgr/items/361d339d2739792457ab
    - selfが隠れている！！