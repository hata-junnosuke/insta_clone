# README

## 内容
- 投稿のCRUD機能を作ってください

## 補足
- ユーザーとポストのシードファイルを作る
- その際fakerを使ってダミーテキストを生成する
- 画像のアップロードにはcarrierwaveを使用する
- image_magickを使用して、画像は横幅or縦幅が最大1000pxとなるようにリサイズする
- 画像は複数枚アップロードできるようにする
- Swiper使って画像をスワイプできるようにする
- 諸々のアイコンにはfontawesomeを使用する

## 実装メモ
### 1/16
- シードファイルとは
  - 簡単に言うと初期データのこと
  - https://qiita.com/takehanKosuke/items/79a66751fe95010ea5ee
- fakerとは
  - RSpecなどでテストする際に、FactoryBotなどであらかじめデータを用意することがあるが、その際にランダムデータをいい感じに作ってくれるgem
  - seedファイルなんかでも使えば初期データをランダムにいろいろ作成できる。
  - https://github.com/faker-ruby/faker
  - https://qiita.com/koki_73/items/60c2441fb873a8db35d5
- carrierwaveとは
  - CarrierWaveとは、ファイルのアップロード機能を簡単に追加する事が出来るgem
  - https://pikawaka.com/rails/carrierwave
  - https://github.com/carrierwaveuploader/carrierwave
- image_magickとは
  - 画像を操作したり表示したりするためのソフトウェア
  - https://qiita.com/wann/items/99e6de5a8c0ba7b959e8
- Swiperとは
  - Swiper.jsはスライダーが作れるJavaScriptライブラリ
  - https://kiomiru.co.jp/blog/coding/swiper-js/
  - https://swiperjs.com/get-started
- fontawesomeとは
  - Web上にはさまざまなアイコンを無料で用意してくれている便利なサイト
  - https://qiita.com/koki_73/items/fa6d31a3b54a84d19dcf
  - https://fontawesome.com/
### 1/17
- Postsモデル作成（テストができてる。。）
- faker,carrierwaveの導入
- swiperの導入
  - `yarn add swiper`
  - `yarn install`
  - https://qiita.com/ken_ta_/items/bdf04d8ecab6a855e50f
  - みけたさんの記事 https://qiita.com/miketa_webprgr/items/0a3845aeb5da2ed75f82
- routes.rbの編集(この時点ではviewを作っていないのでエラー発生)
- エラー発生
  - Sprockets::FileNotFound
  - 解決はassets/javascripts/swiper.jsを作成して中身を写経したら治った。
  - これは何かのコマンドで作成される？手動が正解？
- アップロードファイルをgit管理対象外にした
- ヘッダー作成
- seedファイル作成
  - db/seeds.rb
  - db/seeds/users,posts
  - `bin/rails db:seed`で作れるがまだpostのcrudがないのでエラー
- postのi18対応
- スマホ対応
- root修正

### 1/18
- コントローラー作成
  - `$ bin/rails g controller posts index show new edit create destroy update`
  - 上でやるとcreateなどのビューもできてしまうミス
- ビューの作成とcss
- carrierwave
  - bundle exec rails g uploader post_image
- CRUD実装
- Swiper
- ルート修正

### TODO
- モデル作成時にテストが作成されている。
  - `g.test_framework false`をconfig/appに記述することで解決
  - https://qiita.com/kodai_0122/items/14494a3848654f32909d
- routesの順番変えたのはなぜ？
  - おそらくresourcesをまとめた。
- スマホ対応　
  - `meta[name="viewport" content="width=device-width, initial-scale=1.0"]`
  - この記述によって画面の大きさによってサイズを変更していることになる。
  - https://qiita.com/pagk/items/ef3eabe0e9f7fe885284
- constraints ->  request { request.session[:user_id].present? } do
  - https://railsguides.jp/routing.html#:~:text=3.9%20%E3%83%AA%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88%E5%86%85%E5%AE%B9%E3%81%AB%E5%BF%9C%E3%81%98%E3%81%A6%E5%88%B6%E9%99%90%E3%82%92%E5%8A%A0%E3%81%88%E3%82%8B
  - https://blog.piyo.tech/posts/2018-03-31-routes-constraints/
  - constraintsで制限を加えることができる。
- `require_login`ってどこかで書いたっけ？
  - sorcery.controllerに入っている。
  - 同様にlogin,current_userなどもここに記述があった。
- 複数の画像を保存する
  - https://qiita.com/tanutanu/items/47f8a229ef52cae3c251
  - モデルにserialize :images, JSON
  - コントローラーにimages: []
  - ビューにmultiple: true
