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
### 1/27
1. まずはUserモデルにアバター用のカラムを追加する
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
2. 編集画面は/mypage/account/editというパスとする
- routes.rb
```bigquery
namespace :mypage do
    resource :account, only: %i[edit update]
end
```
3. 画像のセッティング（carrierwave）
- userモデル
```
# 画像セットのため
  mount_uploader :avatar, AvatarUploader
```
- avatar_uploader.rb作成

4. プロフィール編集画面の実装



## 学習ポイント
### 編集画面は/mypage/account/editというパスとする

### アバターとユーザー名を変更できるようにする

### アバター選択時（ファイル選択時）にプレビューを表示する

### image_magickを使用して、画像は横幅or縦幅が最大400pxとなるようにリサイズする

### 以降の課題でもマイページに諸々追加するのでそれを考慮した設計とする（ルーティングやコントローラやレイアウトファイルなど）

メモ
- mypageで扱う理由
- 利点は編集のURLでIDがわからない？
- userコントローラーでeditでは良くないのか。
- mypage/account_controllerは一気に作れないか？（rails g controllerのように）
- layoutに入れるviewなぜ？