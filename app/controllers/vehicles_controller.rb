class VehiclesController < ApplicationController
  
  def index
    dealership = current_user.dealership
    vehicles = dealership.vehicles.includes(:current_parking_tag)
    
    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        vehicles = vehicles.order(k => v)
      end
    end

    @vehicles = vehicles
  end

  def show
    @vehicle = Vehicle.find(params[:id])
  end

  def new
  end

  def create
    Vehicle.create(vehicle_params)
    redirect_to vehicles_path
  end

  def search
    dealership = current_user.dealership
    @vehicles = dealership.vehicles.includes(:current_parking_tag).where('stock_number ilike ?', "%#{params[:stock_number]}%")
    render :index
  end


  private
    def vehicle_params
      params.require(:vehicle).permit(:make, :model, :year, :vin, :dealership_id, :is_used )
    end
end
