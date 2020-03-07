FactoryBot.define do
  factory :dns_record do
    ip_address { Faker::Internet.unique.ip_v4_address }
  end
end
