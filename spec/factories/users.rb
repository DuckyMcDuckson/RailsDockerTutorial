FactoryBot.define do
  factory :user do
    name { 'テスト太郎' }
    sequence :email do |n|
      "test#{n}@example.com"
    end
    password { 'TestPassword' }
    password_confirmation { 'TestPassword' }
  end
end
