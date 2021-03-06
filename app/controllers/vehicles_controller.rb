class VehiclesController < ApplicationController

  def index
    @dealership = current_user.dealership
    @vehicles = @dealership.vehicles.includes(:current_parking_tag, :open_service_tickets)

    if params.dig(:stock_number_or_vin).present?
      @vehicles = @vehicles.where('stock_number ilike ? OR vin ilike ?', "%#{params[:stock_number_or_vin]}%", "%#{params[:stock_number_or_vin]}%")
    end

    if params.dig(:filter, :usage_type).present?
      @vehicles = @vehicles.where(usage_type: params.dig(:filter, :usage_type))
    end

    if params.dig(:filter, :creation_source).present?
      @vehicles = @vehicles.where(creation_source: params.dig(:filter, :creation_source))
    end

    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        @vehicles = @vehicles.order(k => v)
      end
    end

    #model filters should only ever show new vehicles
    if params.dig(:filter, :model).present?
      @vehicles = @vehicles
                    .where(usage_type: 'is_new', model: params.dig(:filter, :model))
                    .order(age_in_days: :desc)
    end

    if params.dig(:filter, :trim_level).present?
      @vehicles = @vehicles
                    .where(trim_level: params.dig(:filter, :trim_level))
    end

    if params.dig(:filter, :no_tag).present?
      @vehicles = Vehicle.where(id: Vehicle.missing_tags(@dealership, @vehicles).pluck(:id))
      @deleted_vehicles = @dealership.vehicles.only_deleted
    end

    @vehicles = @vehicles.page(params[:page]).per(50)
  end

  def update
    @vehicle = Vehicle.find(params[:id])
    @vehicle.update(vehicle_params)
    @events = @vehicle.events.includes(:user, :resolutions) #needed to re-render
    flash.now[:success] = 'Vehicle update saved'
    VehicleHoldUpdaterService.new(@vehicle, vehicle_params, current_user).maybe_update_holds

  end

  def show
    @vehicle = Vehicle.find(params[:id])
    @events = @vehicle.events.includes(:user, :resolutions)
  end

  def show_info_modal
    @vehicle = current_user.dealership.vehicles.includes(:tags).find(params[:vehicle_id])
    @events = @vehicle.events.includes(:user, :resolutions)
    @context = "lot_view"
  end


  #used to toggle the map modal only
  def show_map
    @vehicle = Vehicle.find(params[:vehicle_id])
    @events = @vehicle.events.includes(:user, :resolutions)
    dealership = current_user.dealership

    @parking_lot_name = @vehicle.parking_space.parking_lot.name

    @redirect_to_link = params[:redirect_to_link]

    @vehicle_color = @vehicle.map_color
  end

  def new
  end

  # route used by ajax request to populate colored pills
  def inventory_count
    dealership = current_user.dealership
    vehicles = dealership.vehicles

    @grouped_vehicles = vehicles.group(:usage_type).count

    @vehicles_missing_tags_length = Vehicle.missing_tags(dealership, vehicles).length

  end

  # route used by right side of VM page to render grouped new vehicles
  def new_vehicle_groupings
    dealership = current_user.dealership
    @vehicles = dealership
                  .vehicles
                  .where(usage_type: "is_new")
                  .data_feed_created
                  .group_by(&:model).sort_by{ |key| key }
                  .to_h
  end

  def user_created_vehicle_groupings
    dealership = current_user.dealership
    @vehicles = dealership
                  .vehicles
                  .where(usage_type: ["is_new", "is_used", "wholesale_unit"] )
                  .user_created
                  .group_by(&:usage_type).sort_by{ |key| key }
                  .to_h
  end


  def create
    Vehicle.user_created.create(vehicle_params)

    Event.create(event_type: :create_vehicle, user: current_user, event_details: vehicle_params.to_unsafe_h)

    redirect_to vehicles_path
  end

  def destroy
    @dealership = current_user.dealership
    vehicle = @dealership.vehicles.find(params[:id])
    vehicle.destroy

    #when triggering delete from a filtered lot view, sometimes there will be a display mode
    if params[:display_mode].present?
      redirect_to lot_view_path(display_mode: params[:display_mode])
    elsif params[:redirect_to_link].present?
      redirect_to params[:redirect_to_link]
    else
      redirect_to vehicles_path
    end
  end


  def print_hold_tag
    @vehicle = Vehicle.find(params[:vehicle_id])
    respond_to do |format|
     format.pdf do
       render pdf: "Hold Tag - #{@vehicle.stock_number}",
       template: "vehicles/hold_tag.html.haml",
       orientation: "Landscape",
       layout: 'pdf.html.erb'
     end
    end
  end

  def print_service_hold_tag
    @vehicle = Vehicle.find(params[:vehicle_id])
    respond_to do |format|
     format.pdf do
       render pdf: "Hold Tag - #{@vehicle.stock_number}",
       template: "vehicles/service_hold_tag.html.haml",
       orientation: "Landscape",
       layout: 'pdf.html.erb'
     end
    end
  end

  private
    def user_for_paper_trail
      current_user.full_name
    end

    def vehicle_params
      params.require(:vehicle).permit(:make, :model, :year, :vin, :color, :dealership_id, :usage_type, :sales_hold, :service_hold, :sales_hold_notes, :service_hold_notes, :stock_number )
    end

end
