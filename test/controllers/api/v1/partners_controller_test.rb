require 'test_helper'

class Api::V1::PartnersControllerTest < ActionDispatch::IntegrationTest
  describe 'Api::V1::PartnersController' do
    let (:url) { "/api/v1/partners" }

    let (:partner) { create(:partner) }

    describe 'show' do
      it 'should return the specific partner' do
        get "#{url}/#{partner.id}"

        json = JSON.parse(@response.body)

        assert_response :success
        assert_equal partner.id, json['id']
        assert_equal partner.materials, json['materials']
        assert_equal partner.lat, json['lat']
        assert_equal partner.lng, json['lng']
        assert_equal partner.radius, json['radius']
        assert_equal partner.rating, json['rating']
      end

      it 'should return not found error if partner not found' do
        get "#{url}/-1"

        json = JSON.parse(@response.body)
        assert_response 404

        expected_response = "Partner with id -1 was not found"
        assert_equal expected_response, json['errors']
      end
    end

    describe 'index' do
      let (:customer_request) { create(:customer_request, lat: 13.013111, lng: 79.891900, material: 'carpet') }

      let (:partner1) { create(:partner, lat: 13.016111, lng: 79.861900, radius: 200, materials: ['wood']) }
      let (:partner2) { create(:partner, lat: 13.016111, lng: 79.861900, radius: 200, materials: ['carpet'], rating: 4) }
      let (:partner3) { create(:partner, lat: 13.023111, lng: 79.881900, radius: 100, materials: ['carpet', 'wood'], rating: 4) }
      let (:partner4) { create(:partner, lat: 39.013111, lng: 19.891900, radius: 100, materials: ['tiles']) }
      let (:partner5) { create(:partner, lat: 13.016111, lng: 79.861900, radius: 200, materials: ['carpet'], rating: 5) }

      it 'should return all the partners matching the customer request in order, first by rating and then by distance' do
        partner1; partner2; partner3; partner4; partner5
        get "#{url}/match/#{customer_request.id}"

        json = JSON.parse(@response.body)
        assert_response :success
        assert_equal [partner5.id, partner3.id, partner2.id], [json[0]['id'], json[1]['id'], json[2]['id']]
      end

      it 'should return not found error if customer request not found' do
        get "/#{url}/match/-1"

        json = JSON.parse(@response.body)
        assert_response 404

        expected_response = "Customer request with id -1 was not found"
        assert_equal expected_response, json['errors']
      end
    end

  end
end
