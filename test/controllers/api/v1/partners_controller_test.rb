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



  end
end
