require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do

  describe 'ユーザー登録' do
    context '入力情報が正しい場合' do
      it 'ユーザー登録ができること' do
        visit new_user_path
        fill_in 'ユーザー名', with: 'Rails太郎'
        fill_in 'メールアドレス', with: 'rails@example.com'
        fill_in 'パスワード', with: '12345678'
        fill_in 'パスワード確認', with: '12345678'
        click_button '登録'
        expect(current_path).to eq login_path
        expect(page).to have_content 'ユーザーを作成しました'
      end
    end

    context '入力情報に誤りがある場合' do
      it 'ユーザー登録が失敗すること' do
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