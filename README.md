# README

## 内容
- 投稿に対するコメントのCRUD機能を実装してください。

## 補足
- 編集・更新はモーダルを表示させ非同期で行う。form_withを利用すること。
- 文字列長など適切なバリデーションを付与する
- shallowルーティングを使用する

## 開発メモ
### 1/22
- git flow feature start 04_comment_to_post
- git pull origin feature/03_pagenation

### 1/23
- shallowルーティングとは
  - https://qiita.com/tanutanu/items/a245f7691c77b56d4cd3
  - ネストしたルーティングにおいて、下層にあるテーブルのIDが一意なら、その上にあるテーブルのIDは不要という発想に基づいて、 edit、show、update、destroyの４アクションで、URIパターンがスッキリし、ヘルパーメソッドも短くなったルーティング手段。

- ` bundle exec rails g model comment user:references post:references body:text`
- `bundle exec rails db:migrate`
- ` bundle exec rails g controller comments `
- post/showにcommentのインスタンス記述
- userとpostモデルに関連づけ
- viewの作成
- shallowルーティング

## TODO
- `.merge(post_id: params[:post_id])`
  - https://qiita.com/zenfumi/items/694edc863527f91c8976
  - commentモデルに関して送られるパラメータ以外にpost_idを含めたので今回使用している。
- `.build(comment_params)`
  - https://qiita.com/ryosuke-endo/items/6bae532b4f678fdcf87d
  - ここは二つのモデルを結合する時にはbuildを使うのが慣習らしい。（QAアプリでもやったぞ）
- partialあたりを理解する
  - https://pikawaka.com/rails/partial_template
  - partialオプション、localオプションもあるということを学習。
- modalも確認
  - https://www.sejuku.net/blog/78105
  - すごく雑に書くと
    - modal-header」で画面名やタイトルを書くヘッダー部分
    -「modal-body」で詳細な内容を書くボディ部分
    -「modal-footer」でボタンなど置くフッター部分
- bigint
  - integerで作成してしまうとforeign keyが作成できない。そのため、テーブルのカラムをbigintで作成する必要がある。
  - なお、rails5よりidに対してデフォルトらしい。
- javascriptが機能していない。renderがうまくいかない。
  - ファイル名の最後にインデントがあって反応しなかった。
- bootstrapのcss
  - https://webnetamemo.com/coding/bootstrap4/201906138320