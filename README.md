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
  - 

