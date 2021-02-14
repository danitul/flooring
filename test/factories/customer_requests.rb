FactoryBot.define do
  factory :customer_request do
    material { Partner::MATERIALS.first }
    lat { 13.013111 }
    lng { 79.891900 }
    area { 10 }
    phone { 123456789 }
  end
end
