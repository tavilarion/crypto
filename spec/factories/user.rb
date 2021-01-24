FactoryBot.define do
  factory :user do
    email { 'test@local.en' }
    encrypted_password { BCrypt::Password.create("password") }
  end
end
