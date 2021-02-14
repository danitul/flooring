require "test_helper"

describe CustomerRequest do
  it 'should create a customer request correctly' do
    assert_equal 0, CustomerRequest.count
    create(:customer_request)
    assert_equal 1, CustomerRequest.count
  end

  describe 'validations' do
    it "does not create a customer request with an unknown material" do
      assert_raises ActiveRecord::RecordInvalid do
        create(:customer_request, material: 'abc')
      end
    end
  end
end