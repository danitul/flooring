# Here Customers have access to actions related to matching partners
class Api::V1::PartnersController < ApplicationController
  def show
    partner = Partner.find_by(id: params[:id])

    if partner
      render json: partner, status: 200
    else
      render json: { errors: "Partner with id #{params[:id]} was not found"}, status: 404
    end
  end

  # There are different ways to design this. Without further information I chose to save a customer request in the db
  # and then use it from there, instead of sending the required info through params.
  # This assures me the data is supposed to be already validated.
  def index
    customer_request = CustomerRequest.find_by(id: params[:customer_request_id])
    if !customer_request.nil?
      #here we could give more detailed error messaging, if for example there is no matching partner in the customer's area.
      partners = Partner.select_with_distance_from_home(customer_request.lat, customer_request.lng)
                        .with_expertise(customer_request.material)
                        .within_radius(customer_request.lat, customer_request.lng)
                        .order_by_rating
                        .order_by_distance_from_home
      render json: partners.to_json, status: 200
    else
      render json: { errors: "Customer request with id #{params[:customer_request_id]} was not found"}, status: 404
    end
  end

end

