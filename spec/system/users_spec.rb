require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  # ユーザー情報入力用の変数
  let(:name) { 'テスト太郎' }
  let(:email) { 'test@example.com' }
  let(:password) { 'password' }
  let(:password_confirmation) { password }
  let(:password_form_input) { password }

  describe 'ユーザー登録機能の検証' do
    before { visit '/users/sign_up' }

    # ユーザー登録を行う一連の操作を subject にまとめる
    subject do
      fill_in 'user_name', with: name
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password_confirmation
      click_button 'ユーザー登録'
    end

    context '正常系' do
      it 'ユーザーを作成できる' do
        ActionMailer::Base.deliveries.clear
        subject
        expect(current_path).to eq('/') # ユーザー登録後はトップページにリダイレクト
        expect(page).to have_content(I18n.t('devise.registrations.signed_up_but_unconfirmed'))
        expect(ActionMailer::Base.deliveries.last.body).to include('You can confirm your account email through the link below:')
      end
    end

    context '異常系' do
      context 'エラー理由が1件の場合' do
        let(:name) { '' }
        it 'ユーザー作成に失敗した旨のエラーメッセージを表示する' do
          subject
          expect(page).to have_content(
            format(
              I18n.t('errors.messages.not_saved.one'),
              resource: I18n.t('activerecord.models.user')
            )
          )
        end
      end

      context 'エラー理由が2件以上の場合' do
        let(:name) { '' }
        let(:email) { '' }
        it '問題件数とともに、ユーザー作成に失敗した旨のエラーメッセージを表示する' do
          subject
          expect(page).to have_content(
            format(
              I18n.t('errors.messages.not_saved.other'),
              count: 2,
              resource: I18n.t('activerecord.models.user')
            )
          )
        end
      end

      context 'nameが空の場合' do
        let(:name) { '' }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count) # Userが増えない
          expect(page).to have_content([
            I18n.t('activerecord.attributes.user.name'),
            I18n.t('activerecord.errors.models.user.attributes.name.blank')
          ].join(' '))
        end
      end

      context 'nameが20文字を超える場合' do
        let(:name) { 'あ' * 21 }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)

          # https://stackoverflow.com/a/6015467
          max_name_length = User.validators_on(:name)[0].options[:maximum]
          expect(page).to have_content([
            I18n.t('activerecord.attributes.user.name'),
            format(
              I18n.t('activerecord.errors.models.user.attributes.name.too_long'),
              count: max_name_length
            )
          ].join(' '))
        end
      end

      context 'emailが空の場合' do
        let(:email) { '' }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content([
            I18n.t('activerecord.attributes.user.email'),
            I18n.t('activerecord.errors.models.user.attributes.email.blank')
          ].join(' '))
        end
      end

      context 'passwordが空の場合' do
        let(:password) { '' }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content([
            I18n.t('activerecord.attributes.user.password'),
            I18n.t('activerecord.errors.models.user.attributes.password.blank')
          ].join(' '))
        end
      end

      context 'passwordが6文字未満の場合' do
        let(:password) { 'a' * 5 }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content([
            I18n.t('activerecord.attributes.user.password'),
            format(I18n.t('activerecord.errors.models.user.attributes.password.too_short'), count: User.password_length.begin)
          ].join(' '))
        end
      end

      context 'passwordが128文字を超える場合' do
        let(:password) { 'a' * 129 }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content([
            I18n.t('activerecord.attributes.user.password'),
            format(I18n.t('activerecord.errors.models.user.attributes.password.too_long'), count: User.password_length.end)
          ].join(' '))
        end
      end

      context 'passwordとpassword_confirmationが一致しない場合' do
        let(:password_confirmation) { "#{password}hoge" } # passwordに"hoge"を足した文字列にする
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content([
            I18n.t('activerecord.attributes.user.password_confirmation'),
            I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation')
          ].join(' '))
        end
      end
    end
  end

  describe 'ログイン機能の検証' do
    before do
      user = create(:user, name:, email:, password:, password_confirmation:)
      user.confirm

      visit '/users/sign_in'
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password_form_input
      click_button 'ログイン'
    end

    context '正常系' do
      it 'ログインに成功し、トップページにリダイレクトする' do
        expect(current_path).to eq('/')
      end

      it 'ログイン成功時のフラッシュメッセージを表示する' do
        expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
      end
    end

    context '異常系' do
      let(:password_form_input) { "#{password}hoge" }

      it 'ログインに失敗し、ページ遷移しない' do
        expect(current_path).to eq('/users/sign_in')
      end

      it 'ログイン失敗時のフラッシュメッセージを表示する' do
        expect(page).to have_content(
          format(
            I18n.t('devise.failure.invalid'),
            authentication_keys: I18n.t('activerecord.attributes.user.email')
          )
        )
      end
    end
  end

  describe 'ログアウト機能の検証' do
    before do
      user = create(:user, name:, email:, password:, password_confirmation:)
      user.confirm
      sign_in user
      visit '/'
      click_button 'ログアウト'
    end

    it 'トップページにリダイレクトする' do
      expect(current_path).to eq('/')
    end

    it 'ログアウト時のフラッシュメッセージを表示する' do
      expect(page).to have_content(I18n.t('devise.sessions.signed_out'))
    end
  end

  describe 'ナビゲーションバーの検証' do
    context 'ログインしていない場合' do
      before { visit '/' }

      it 'ユーザー登録リンクを表示する' do
        expect(page).to have_link('ユーザー登録', href: '/users/sign_up')
      end

      it 'ログインリンクを表示する' do
        expect(page).to have_link('ログイン', href: '/users/sign_in')
      end

      it 'ログアウトリンクは表示しない' do
        expect(page).not_to have_content('ログアウト')
      end
    end

    context 'ログインしている場合' do
      before do
        user = create(:user)
        user.confirm
        sign_in user
        visit '/'
      end

      it 'ユーザー登録リンクは表示しない' do
        expect(page).not_to have_link('ユーザー登録', href: '/users/sign_up')
      end

      it 'ログインリンクは表示しない' do
        expect(page).not_to have_link('ログイン', href: '/users/sign_in')
      end

      it 'ログアウトリンクを表示する' do
        expect(page).to have_content('ログアウト')
      end

      it 'ログアウトリンクが機能する' do
        click_button 'ログアウト'

        # ログインしていない状態のリンク表示パターンになることを確認
        expect(page).to have_link('ユーザー登録', href: '/users/sign_up')
        expect(page).to have_link('ログイン', href: '/users/sign_in')
        expect(page).not_to have_button('ログアウト')
      end
    end
  end
end
