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


end

