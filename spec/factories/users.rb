FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { '12345678' }
    password_confirmation { '12345678' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
