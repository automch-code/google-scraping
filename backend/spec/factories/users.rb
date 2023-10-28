FactoryBot.define do
  factory :user do
    sequence(:email)                  { |n| "test#{n}@example.com" }
    password                          { SecureRandom.base64 64 }
    password_confirmation             { password }
    confirmed_at                      { Time.current }
    role                              { User.roles[:admin] }
  end
end
