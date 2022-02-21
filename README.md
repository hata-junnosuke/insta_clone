# README

# 07 投稿の検索機能を実装する

## 内容
検索機能を実装してください

## 補足
- 全ての投稿を検索対象とすること（フィードに対する検索ではない）
- 検索条件としては以下の三つとする 
  - 本文に検索ワードが含まれている投稿
    - こちらに関しては半角スペースでつなげることでor検索ができるようにする。e.g.「rails ruby」
  - コメントに検索ワードが含まれている投稿
  - 投稿者の名前に検索ワードが含まれている投稿
- ransackなどの検索用のGemは使わず、フォームオブジェクト、ActiveModelを使って実装すること
- 検索時のパスは/posts/searchとすること

## 開発メモ
### 1/26
- 実装方法を考察
  - https://techacademy.jp/magazine/22330
  - しかし実装方法が結構違うので、解答例のコミットを追いながら学習する。
- route collectionブロック
  - （Railsガイド）GETリクエスト+/photos/searchなどの（idを伴わない）パスを認識し、リクエストをPhotosコントローラのsearchアクションにルーティングします。このときsearch_photos_urlやsearch_photos_pathルーティングヘルパーも同時に作成されます。
- 検索のスコープをpostモデルに追加
- 検索用のコントローラ
- 検索用のビュー
- コメントとユーザーからも検索できるようにする
- 


## 疑問
- FormObject、search_postのあたりの理解
  - https://tech-essentials.work/questions/160
  - https://tech-essentials.work/courses/11/tasks/15/outputs/54
  - strip..文字列先頭と末尾の空白文字を全て取り除いた文字列を生成して返します。
  - .split(/[[:blank:]]+/)は空白で区切っている。
  - ActiveModel,ActiveRecordそれぞれの機能
- .fetchとは？
  - fetchメソッドは引数にハッシュのキーを指定することにより、そのキーとセットになっているバリューを取り出します。
  - fetchメソッドでは第二引数にデフォルトのバリューを設定することができます。
  - application_controllerで空のハッシュをデフォルトとしている。
- injectとは？
  - https://www.sejuku.net/blog/19219
  - injectはeachやmapと同じように繰り返しを行うメソッドです。
  - 配列オブジェクト.inject {|初期値, 要素| ブロック処理 }
- ransackの偉大さを感じる
- 
