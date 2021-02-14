require "test_helper"

describe Partner do
  it 'should create a partner correctly' do
    assert_equal 0, Partner.count
    create(:partner)
    assert_equal 1, Partner.count
  end

  it 'should create a partner with a combination of materials correctly' do
    assert_equal 0, Partner.count
    create(:partner, materials: Partner::MATERIALS.first(2))
    assert_equal 1, Partner.count
    assert_equal Partner::MATERIALS.first(2), Partner.last.materials
  end

  describe 'validations' do
    it "does not create a partner with an unknown material" do
      assert_raises ActiveRecord::RecordInvalid do
        create(:partner, materials: ['abc'])
      end
    end
  end
  
end


