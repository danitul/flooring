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

  describe 'scopes' do
    describe 'with expertise' do
      let (:partner1) { create(:partner, materials: ['wood']) }
      let (:partner2) { create(:partner, materials: ['carpet']) }
      let (:partner3) { create(:partner, materials: ['tiles']) }
      let (:partner4) { create(:partner, materials: ['wood', 'carpet']) }

      it 'should return only partners with a specific expertise' do
        partner1; partner2; partner3; partner4
        partners = Partner.with_expertise(['carpet'])
        assert_equal 2, partners.size
        assert_equal [partner2.id, partner4.id], [partners.first.id, partners.last.id]
      end
    end

    describe 'distance' do
      let (:lat) { 13.013111 }
      let (:lng) { 79.891900 }
      let (:partner1) { create(:partner, lat: 13.016111, lng: 79.861900, radius: 200) }
      let (:partner2) { create(:partner, lat: 13.016111, lng: 79.861900, radius: 5) }
      let (:partner3) { create(:partner, lat: 13.023111, lng: 79.881900, radius: 100) }
      let (:partner4) { create(:partner, lat: 39.013111, lng: 19.891900, radius: 100) }

      describe 'within radius' do
        it 'should return only partners for which the customer is within radius from home' do
          partner1; partner2; partner3; partner4
          partners = Partner.within_radius(lat, lng)
          assert_equal 2, partners.size
          assert_equal [partner1.id, partner3.id], [partners.first.id, partners.last.id]
        end
      end

      describe 'order by distance from home' do
        it 'should return partners descending based on their distance from home' do
          partner1; partner2; partner3; partner4
          partners = Partner.select_with_distance_from_home(lat, lng)
                            .order_by_distance_from_home
          assert_equal 4, partners.size
          assert_equal [partner3.id, partner1.id, partner2.id, partner4.id], partners.map(&:id)
        end
      end
    end

    describe 'order by rating' do
      let (:partner1) { create(:partner, rating: 1) }
      let (:partner2) { create(:partner, rating: 5) }
      let (:partner3) { create(:partner, rating: 4) }
      let (:partner4) { create(:partner, rating: 2) }

      it 'should return partners ordered descending by their rating' do
        partner1; partner2; partner3; partner4
        partners = Partner.order_by_rating
        assert_equal 4, partners.size
        assert_equal [partner2.id, partner3.id, partner4.id, partner1.id], partners.map(&:id)
      end
    end
  end
end


