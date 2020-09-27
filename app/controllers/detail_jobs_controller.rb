class DetailJobsController < ApplicationController

  def index
    @detail_jobs = current_user.dealership.detail_jobs.includes(:sales_rep, :detailer, vehicle: :events).order(must_be_completed_by: :desc)
  end

  def create
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.create!(detail_job_params)

    if params[:redirect_url].present?
      redirect_to params[:redirect_url]
    else
      redirect_to detail_jobs_path
    end
  end

  def update
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.find(params[:id])
    @detail_job.update(detail_job_params)

    redirect_to detail_jobs_path
  end

  def edit
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.find(params[:id])
  end

  def destroy
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.find(params[:id])
    @detail_job.destroy

    redirect_to detail_jobs_path
  end

  def start_job
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.find(params[:detail_job_id])
    if @detail_job.detailer.present?
      @detail_job.update(started_at: DateTime.now)
    else
      flash[:error] = "You cannot start a job without a detailer"
    end

    redirect_to detail_jobs_path
  end

  def complete_job
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.find(params[:detail_job_id])
    @detail_job.update(completed_at: DateTime.now)

    redirect_to detail_jobs_path
  end

  def reset_job
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.find(params[:detail_job_id])
    @detail_job.update(completed_at: nil, started_at: nil)

    redirect_to detail_jobs_path
  end

  def report
    @dealership = current_user.dealership
    @detail_jobs = @dealership.detail_jobs.includes(:sales_rep, :detailer, :vehicle).where("completed_at >= ?", 30.days.ago.beginning_of_day)

    @grouped_jobs = @detail_jobs.group_by{ |j| j.completed_at.in_time_zone("US/Pacific").to_date }
  end

  def stock_number_search
    @vehicle = current_user.dealership.vehicles.find_by_stock_number(params[:stock_number])
  end

  private
    def detail_job_params
      params
        .require(:detail_job)
        .permit(
            :stock_number,
            :make,
            :model,
            :year,
            :color,
            :jobs,
            :vin,
            :sales_rep_id,
            :detailer_id,
            :add_dealership_default_task_1,
            :add_dealership_default_task_2,
            :add_dealership_default_task_3,
            :add_dealership_default_task_4,
            :special_instructions
          )
        .merge(merged_completed_by_datetime)
    end

    def merged_completed_by_datetime
      if params[:complete_by_date].present? && params[:complete_by_time].present?
        timezone = Time.now.in_time_zone("US/Pacific").zone
        time = DateTime.strptime("#{params[:complete_by_date]} #{params[:complete_by_time]} #{timezone}", "%Y-%m-%d %l:%M %p %Z")
        return {must_be_completed_by: time}
      end
    end

end