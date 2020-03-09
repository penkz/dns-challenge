FactoryBot.define do
  factory :dns_record do
    ip { Faker::Internet.unique.ip_v4_address }

    trait :with_hostnames do
      after :create do |object|
        object.hostnames = build_list(:hostname, 5)
      end
    end
  end
end
