require 'rails_helper'
RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do 
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('SignUp')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'name-title', with: @user.nickname
      fill_in 'email-title', with: @user.email
      fill_in 'password-title', with: @user.password
      fill_in 'password-comfiramation-title', with: @user.password_confirmation
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
    end
  end
end
RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('SignUp')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'name-title', with: ""
      fill_in 'email-title', with: ""
      fill_in 'password-title', with: ""
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq "/users"
    end
  end
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('Login')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'email-title', with: @user.email
      fill_in 'password-title', with: @user.password
      # ログインボタンを押す
      find('input[class="submit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # NewShareやLogoutが表示されていないことを確認する
      expect(page).to have_content('NewShare')
      expect(page).to have_content('Logout')
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('Login')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'email-title', with: ""
      fill_in 'password-title', with: ""
      # ログインボタンを押す
      find('input[class="submit"]').click
      # ログインページへ戻されることを確認する
      visit new_user_registration_path
    end
  end
end