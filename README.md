# README

# 15 モデルスペックを実装

# 内容
モデルスペックを実装してください

# 補足
- ユーザーモデルとポストモデルのスペックは最低限書いてください。その他のモデルは任意とします。
- バリデーション, スコープ, インスタンスメソッドのスペックを書いてください。
- 人によっては本実装がサンプルアプリと異なるため、この解答例が絶対的な正解というわけではありません。

# 今回の構想
- 以下の記事を参考にして解答例のコードリーディングをしていく。
>https://qiita.com/jnchito/items/42193d066bd61c740612

# 実装
## gemの追加
gemの記述と`bundle`
```ruby
  gem 'factory_bot_rails'
  gem 'rspec-rails'
```

## `$ rails generate rspec:install`
```ruby
create  .rspec
      create  spec
      create  spec/spec_helper.rb
      create  spec/rails_helper.rb

```

## FactoryBotの設定
1. spec/rails_helper.rb
    ```ruby
    # FactoryBotを使うため以下を追記  
    
      require 'factory_bot'
    
      config.include FactoryBot::Syntax::Methods
    ```
2. factories/posts.rb(userは省略)
- 仮想の投稿を作成   
```ruby
   FactoryBot.define do
    factory :post do
      body { Faker::Hacker.say_something_smart }
      images { [File.open("#{Rails.root}/spec/fixtures/fixture.png")] }
      user
     end
   end
```

## テスト記述
1. post_spec.rb
```ruby
require 'rails_helper'

RSpec.describe Post, type: :model do
   # describeはテストのグループ化を宣言
   describe 'バリデーション' do 
   # it はテストを example という単位にまとめる役割 
    it '画像は必須であること' do
      post = build(:post, images: nil)
      post.valid?
      expect(post.errors[:images]).to include('を入力してください')
    end

    it '本文は必須であること' do
      post = build(:post, body: nil)
      post.valid?
      expect(post.errors[:body]).to include('を入力してください')
    end

    it '本文は最大1000文字であること' do
      post = build(:post, body: "a" * 1001)
      post.valid?
      expect(post.errors[:body]).to include('は1000文字以内で入力してください')
    end
  end

  describe 'スコープ' do
    describe 'body_contain' do
       # !があるので遅延評価ではない 
      let!(:post) { create(:post, body: 'hello world') }
       # テスト対象のオブジェクト（またはメソッドの実行結果）が明確に一つに決まっている場合にsubject
      subject { Post.body_contain('hello') }
      it { is_expected.to include post }
    end
  end
end
```

2. user_spec.rb
```ruby
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it 'ユーザー名は必須であること' do
      user = build(:user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include('を入力してください')
    end

    it 'ユーザー名は一意であること' do
      user = create(:user)# 先にデータが保存されている必要があるのでcreate
      same_name_user = build(:user, username: user.username)
      same_name_user.valid?
      expect(same_name_user.errors[:username]).to include('はすでに存在します')
    end

    it 'メールアドレスは必須であること' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end

    it 'メールアドレスは一意であること' do
      user = create(:user)
      same_email_user = build(:user, email: user.email)
      same_email_user.valid?
      expect(same_email_user.errors[:email]).to include('はすでに存在します')
    end
  end

  describe 'インスタンスメソッド' do
     # 遅延評価(呼び出されたら発動)
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let(:user_c) { create(:user) }
    let(:post_by_user_a) { create(:post, user: user_a) }
    let(:post_by_user_b) { create(:post, user: user_b) }
    let(:post_by_user_c) { create(:post, user: user_c) }
    describe 'own?' do
      context '自分のオブジェクトの場合' do
        it 'trueを返す' do
          expect(user_a.own?(post_by_user_a)).to be true
        end
      end

      context '自分以外のオブジェクトの場合' do
        it 'falseを返す' do
          expect(user_a.own?(post_by_user_b)).to be false
        end
      end
    end

    describe 'like' do
      it 'いいねできること' do
        expect { user_a.like(post_by_user_b) }.to change { Like.count }.by(1)
      end
    end

    describe 'unlike' do
      it 'いいねを解除できること' do
        user_a.like(post_by_user_b)
        expect { user_a.unlike(post_by_user_b) }.to change { Like.count }.by(-1)
      end
    end

    describe 'like' do
      it 'フォローできること' do
        expect { user_a.follow(user_b) }.to change { Relationship.count }.by(1)
      end
    end

    describe 'unlike' do
      it 'フォローを外せること' do
        user_a.follow(user_b)
        expect { user_a.unfollow(user_b) }.to change { Relationship.count }.by(-1)
      end
    end

    describe 'following?' do
       # contextは条件を振り分ける時使う
       context 'フォローしている場合' do
        it 'trueを返す' do
          user_a.follow(user_b)
          expect(user_a.following?(user_b)).to be true
        end
      end

      context 'フォローしていない場合' do
        it 'falseを返す' do
          expect(user_a.following?(user_b)).to be false
        end
      end
    end

    describe 'feed' do
      before do
        user_a.follow(user_b)
      end
      subject { user_a.feed }
      it { is_expected.to include post_by_user_a }
      it { is_expected.to include post_by_user_b }
      it { is_expected.not_to include post_by_user_c }
    end
  end
end
```
3. テストを実行
```ruby
$ bundle exec rspec
2022-02-04 19:15:31 WARN Selenium [DEPRECATION] [:driver_path] Selenium::WebDriver::Chrome#driver_path= is deprecated. Use Selenium::WebDriver::Chrome::Service#driver_path= instead.
.DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <top (required)> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/post_spec.rb:12)
.DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <top (required)> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/post_spec.rb:18)
.DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (4 levels) in <top (required)> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/post_spec.rb:26)
.....DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:36)
.DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:37)
.DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:37)
.DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:37)
.....DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:36)
.DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:37)
.DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <main> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/user_spec.rb:38)
.

Finished in 0.62209 seconds (files took 1.22 seconds to load)
19 examples, 0 failures

```
ちなみに、限定的に実行するには

`$ bundle exec rspec spec/models/user_spec.rb`

4. わざと失敗させてテストが機能していることを確かめる
- 1001のところを999文字にする
```ruby
# post_spec.rb

 it '本文は最大1000文字であること' do
      post = build(:post, body: "a" * 999)
      post.valid?
      expect(post.errors[:body]).to include('は1000文字以内で入力してください')
 end
```
- すると結果は？
```ruby
$ bundle exec rspec spec/models/post_spec.rb
2022-02-04 20:49:32 WARN Selenium [DEPRECATION] [:driver_path] Selenium::WebDriver::Chrome#driver_path= is deprecated. Use Selenium::WebDriver::Chrome::Service#driver_path= instead.
.DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <top (required)> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/post_spec.rb:12)
.DEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (3 levels) in <top (required)> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/post_spec.rb:18)
FDEPRECATION WARNING: #extension_whitelist is deprecated, use #extension_allowlist instead. (called from block (4 levels) in <top (required)> at /Users/hatajunnosuke/RubymineProjects/insta_clone/spec/models/post_spec.rb:26)
.

Failures:

  1) Post バリデーション 本文は最大1000文字であること
     Failure/Error: expect(post.errors[:body]).to include('は1000文字以内で入力してください')
       expected [] to include "は1000文字以内で入力してください"
     # ./spec/models/post_spec.rb:20:in `block (3 levels) in <top (required)>'

Finished in 0.32194 seconds (files took 1.4 seconds to load)
4 examples, 1 failure

Failed examples:

rspec ./spec/models/post_spec.rb:17 # Post バリデーション 本文は最大1000文字であること

```
- 失敗した！つまり、テストが機能している事を確認できた。
## まとめ
>https://qiita.com/jnchito/items/42193d066bd61c740612

この上の記事を参考にまとめる
- describe / it / expect の役割
   - describeはテストのグループ化を宣言
   - it はテストを example という単位にまとめる役割
   - expect(X).to eq Y で記述するのがエクスペクテーション
- ネストした describe
   - describe はいくつでも書けますし、ネストさせることもできます
   - 適切にグループ化すると、「この describe ブロックはこの機能をテストしてるんだな」と読み手がテストコードを理解しやすくなります。
- context の使い方
  - context という機能でテストをグループ化することもできます。
  - context は条件を分けたりするときに使うことが多いです。(「〇〇な場合」みたいな感じで使う)
  - describe と同様、 context で適切にグループ化すると、「この context ブロックはこういう条件の場合をテストしてるんだな」と読み手がテストコードを理解しやすくなります。
- before の使い方
   - before do ... end で囲まれた部分は example の実行前に毎回呼ばれます。
   - before ブロックの中では、テストを実行する前の共通処理やデータのセットアップ等を行うことが多いです。
- let / let! / subject の使い方
   - let は「before + インスタンス変数」を使うときとは異なり、 遅延評価される という特徴があります。
     すなわち、 let は必要になる瞬間まで呼び出されません。
   - let! を使うと example の実行前に let! で定義した値が作られるようになります。（遅延評価はない）
   - テスト対象のオブジェクト（またはメソッドの実行結果）が明確に一つに決まっている場合は、 subject という機能を使ってテストコードをDRYにすることができます。
   
## コメント
- RSpecはポートフォリオでも使ったのでイメージはしやすかったです。
- この課題を機に似たようなdescribeやcontextの使い分けを学べてよかったです。