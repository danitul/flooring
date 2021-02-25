FactoryBot.define do
  factory :partner do
    materials do
      Array.new() { Partner::MATERIALS.first }
    end
    lat { 13.012111 }
    lng { 79.899900 }
    min_area { 5 }
    max_area { 20 }
    radius { 10 }
    rating { 4 }
  end
end
