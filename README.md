# README

# 16 システムスペックを実装

# 内容
モデルスペックを実装してください

# 補足
解答例では以下のスペックを書いています。

- ログイン成功/失敗
- ログアウトできる
- ユーザー登録成功/失敗
- フォローできること
- フォローをはずせること
- 投稿一覧が閲覧できる
- 新規投稿できる
- 自分の投稿に編集・削除ボタンが表示される
- 他人の投稿には編集・削除ボタンが表示されない
- 投稿を更新できる
- 投稿を削除できる
- 投稿の詳細画面が閲覧できる
- 投稿に対していいねできる
- 投稿に対していいねを外せる

# 実装
## gemのインストール
1. capybaraとwebdriversをインストール
```ruby
  gem  'capybara'
  gem 'webdrivers'
```
2. `bundle`
### capybalaとは？
- UIテストのためのrubyフレームワーク
### webdriversについて
- 'chromedriver-helper'というgemもあるがサポートが終了しているので間違わないように注意

## capybaraの設定
1. rails_helper.rb
    ```ruby
    # RSpecで利用する場合は、スペックのヘルパファイルに記述を追加する。
    require 'capybara/rspec'
    # moduleをsystemで使えるように設定
    config.include SystemHelper, type: :system
    ```
2. spec_helper.rb
    ```ruby
    # ドライバーの設定
    config.before(:each, type: :system) do
        driven_by :selenium, using: :headless_chrome, screen_size: [1920, 1080]
    end
    ```

## ログイン・ログアウトのシステムスペック
1. rails_helper.rb

    spec/support/配下のファイルを読み込む設定
    >https://qiita.com/aiandrox/items/7ff4d73416dc15f0cc0f#specsupport%E9%85%8D%E4%B8%8B%E3%81%AE%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%82%80%E8%A8%AD%E5%AE%9A

    ```ruby
    Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
    ```
2. module

    ここでメソッドを事前に作成
    ```ruby
    # support/system_helper.rb
    
    module SystemHelper
      def login
        user = create(:user)
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '12345678'
        click_button 'ログイン'
      end
    
      def login_as(user)
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '12345678'
        click_button 'ログイン'
      end
    end
    ```
3. テスト記述
    ```ruby
    # system/user_sessions/user_session_spec.rb
    
    require 'rails_helper'
    
    RSpec.describe 'ログイン・ログアウト', type: :system do
      let(:user) { create(:user) }
    
      describe 'ログイン' do
        context '認証情報が正しい場合' do
          it 'ログインできること' do
            visit login_path
            fill_in 'メールアドレス', with: user.email
            fill_in 'パスワード', with: '12345678'
            click_button 'ログイン'
            expect(current_path).to eq posts_path
            expect(page).to have_content 'ログインしました'
          end
        end
    
        context '認証情報に誤りがある場合' do
          it 'ログインできないこと' do
            visit login_path
            fill_in 'メールアドレス', with: user.email
            fill_in 'パスワード', with: '1234'
            click_button 'ログイン'
            expect(current_path).to eq login_path
            expect(page).to have_content 'ログインに失敗しました'
          end
        end
      end
    
      describe 'ログアウト' do
        before do
          login
        end
    
        it 'ログアウトできること' do
          click_on('ログアウト')
          expect(current_path).to eq login_path
          expect(page).to have_content 'ログアウトしました'
        end
      end
    end
    ```
   - ユーザーに関するところでコードリーディング
       ```ruby
       # spec/system/users/users_spec.rb
   
       require 'rails_helper'

       RSpec.describe 'ユーザー登録', type: :system do
       describe 'ユーザー登録' do
        context '入力情報が正しい場合' do
         it 'ユーザー登録ができること' do
          visit new_user_path
          # fill_inとwithでフォームを埋めている
          fill_in 'ユーザー名', with: 'Rails太郎'
          fill_in 'メールアドレス', with: 'rails@example.com'
          fill_in 'パスワード', with: '12345678'
          fill_in 'パスワード確認', with: '12345678'
          click_button '登録'
          expect(current_path).to eq login_path
           # have_contentで文字列の表示を検証する
          expect(page).to have_content 'ユーザーを作成しました'
         end
        end
    
        context '入力情報に誤りがある場合' do
             it 'ユーザー登録に失敗すること' do
               visit new_user_path
               fill_in 'ユーザー名', with: ''
               fill_in 'メールアドレス', with: ''
               fill_in 'パスワード', with: ''
               fill_in 'パスワード確認', with: ''
               click_button '登録'
               expect(page).to have_content 'ユーザー名を入力してください'
               expect(page).to have_content 'メールアドレスを入力してください'
               expect(page).to have_content 'パスワードは3文字以上で入力してください'
               expect(page).to have_content 'パスワード確認を入力してください'
               expect(page).to have_content 'ユーザーの作成に失敗しました'
             end
        end
      end
    
       describe 'フォロー' do
       let!(:login_user) { create(:user) }
       let!(:other_user) { create(:user) }
    
           before do
             login_as login_user
           end
           it 'フォローができること' do
             visit posts_path
             expect {
               # withinでスコープをかけてどこを操作しているかを示す
     　　　　　# この場合はother_userのフォローボタンをクリックしたことを指示
               within "#follow-area-#{other_user.id}" do
                 click_link 'フォロー'
                 expect(page).to have_content 'アンフォロー'
               end
             }.to change(login_user.following, :count).by(1)
           end
    
           it 'フォローを外せること' do
             login_user.follow(other_user)
             visit posts_path
             expect {
               within "#follow-area-#{other_user.id}" do
                 click_link 'アンフォロー'
                 expect(page).to have_content 'フォロー'
               end
             }.to change(login_user.following, :count).by(-1)
           end
           end
       end
       ```

## 補足
- .rspecに以下の記述をするとテストの過程がみやすくなる。
    ```ruby
    --require spec_helper
    --format documentation
    ```
- フィーチャスペックで使われるエイリアスの対応関係は以下の通りです。
    - describe <=> feature
    - it <=> scenario
    - let <=> given
    - let! <=> given!
    - before <=> background


## 確認してみよう
```ruby
$ bundle exec rspec
        
        Post
          バリデーション
            画像は必須であること
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <top (required)> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/post_spec.rb:31)
            本文は必須であること
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <top (required)> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/post_spec.rb:37)
            本文は最大1000文字であること
          スコープ
            body_contain
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (4 levels) in <top (required)> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/post_spec.rb:45)
              is expected to include #<Post id: 103, images: ["fixture.png"], body: "hello world", user_id: 225, created_at: "2022-02-05 00:29:16", updated_at: "2022-02-05 00:29:16">
        
        User
          バリデーション
            ユーザー名は必須であること
            ユーザー名は一意であること
            メールアドレスは必須であること
            メールアドレスは一意であること
          インスタンスメソッド
            own?
              自分のオブジェクトの場合
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:56)
                trueを返す
              自分以外のオブジェクトの場合
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:57)
                falseを返す
            like
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:57)
              いいねできること
            unlike
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:57)
              いいねを解除できること
            like
              フォローできること
            unlike
              フォローを外せること
            following?
              フォローしている場合
                trueを返す
              フォローしていない場合
                falseを返す
            feed
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:56)
              is expected to include #<Post id: 108, images: ["fixture.png"], body: "If we reboot the driver, we can get to the CSS dri...", user_id: 243, created_at: "2022-02-05 00:29:17", updated_at: "2022-02-05 00:29:17">
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:57)
              is expected to include #<Post id: 109, images: ["fixture.png"], body: "Backing up the sensor won't do anything, we need t...", user_id: 246, created_at: "2022-02-05 00:29:17", updated_at: "2022-02-05 00:29:17">
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:58)
              is expected not to include #<Post id: 110, images: ["fixture.png"], body: "The SSL matrix is down, connect the neural bus so ...", user_id: 249, created_at: "2022-02-05 00:29:17", updated_at: "2022-02-05 00:29:17">
        
        ポスト
          ポスト一覧
            ログインしている場合
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:6)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:7)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:8)
        2022-02-05 09:29:18 WARN Selenium [DEPRECATION] [:browser_options] :options as a parameter for driver initialization is deprecated. Use :capabilities with an Array of value capabilities/options if necessary instead.
              フォロワーと自分の投稿だけが表示されること
            ログインしていない場合
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:6)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:7)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:8)
              全てのポストが表示されること
          ポスト投稿
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from create at /Users/hatajunnosuke/RubymineProjects/insta_clone/app/controllers/posts_controller.rb:17)
            画像を投稿できること
          ポスト更新
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:51)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:52)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:53)
            自分の投稿に編集ボタンが表示されること
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:51)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:52)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:53)
            他人の投稿には編集ボタンが表示されないこと
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:51)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:52)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:53)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from update at /Users/hatajunnosuke/RubymineProjects/insta_clone/app/controllers/posts_controller.rb:32)
            投稿が更新できること
          ポスト削除
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:89)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:90)
            自分の投稿に削除ボタンが表示されること
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:89)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:90)
            他人の投稿には削除ボタンが表示されないこと
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:89)
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:90)
            投稿が削除できること
          ポスト詳細
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:123)
            投稿の詳細画面が閲覧できること
          いいね
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:137)
            いいねができること
        DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/system/posts/posts_spec.rb:137)
            いいねを取り消せること
        
        ログイン・ログアウト
          ログイン
            認証情報が正しい場合
              ログインできること
            認証情報に誤りがある場合
              ログインできないこと
          ログアウト
            ログアウトできること
        
        ユーザー登録
          ユーザー登録
            入力情報が正しい場合
              ユーザー登録ができること
            入力情報に誤りがある場合
              ユーザー登録が失敗すること
          フォロー
            フォローができること
            フォローを外せること
        
        Finished in 18.2 seconds (files took 2.3 seconds to load)
        38 examples, 0 failures
```
- **総員38名、事故なし、現在員38名、健康状態異常なし！**

## コメント
- システムスペックもポートフォリオで扱ったので理解しやすかったです。
- ポートフォリオではidをビューに付与していなくてうまくテストを動作させられなかった事を思い出しました。
- capybaraはメソッド？がたくさんあるので使用のするときに記事を活用していくことにします。



## 参考
>https://qiita.com/jnchito/items/42193d066bd61c740612
>https://qiita.com/morrr/items/0e24251c049180218db4
> https://qiita.com/aiandrox/items/7ff4d73416dc15f0cc0f