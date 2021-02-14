class CustomerRequest < ApplicationRecord
  validates :material, inclusion: { in: Partner::MATERIALS }
end
