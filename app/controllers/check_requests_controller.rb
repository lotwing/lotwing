class CheckRequestsController < ApplicationController

  def index
    service = CheckRequestSearchService.new(params, current_user.dealership)

    @check_requests = service.perform

    @filters_applied = service.filters_applied
  end

  def new
    @check_request = current_user.dealership.check_requests.new
  end

  def create
    @check_request = current_user.dealership.check_requests.create(check_request_params)

    if params[:commit] == "Print"
      redirect_to check_request_printout_path(@check_request, format: :pdf) and return
    else
      redirect_to edit_check_request_path(@check_request) and return
    end
  end

  def update
    @check_request = current_user.dealership.check_requests.find(params[:id])
    @check_request.update(check_request_params)
    if params[:commit] == "Print"
      redirect_to check_request_printout_path(@check_request, format: :pdf) and return
    else
      redirect_to check_requests_path and return
    end
  end

  def search
    
  end

  def edit
    @check_request = current_user.dealership.check_requests.find(params[:id])
  end


  private
    def check_request_params
      params.require(:check_request).permit(
        :is_check,
        :is_cash,
        :request_by,
        :request_date,
        :department,
        :amount_requested,
        :stock_number,
        :make,
        :model,
        :payable_to,
        :description
      )
    end


end
