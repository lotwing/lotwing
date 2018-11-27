class BoardManagersController < ApplicationController

  def show
    deals = current_user.dealership.deals.where(stored: false)

    if params.dig(:filters, :mtd).present?
      sql = <<~SQL
              CASE 
                WHEN is_used = true 
                  THEN created_at > '"#{Date.today.beginning_of_month}"' 
                ELSE created_at > '"#{current_user.dealership.custom_mtd_start_date}"'
              END    
            SQL

      deals = deals.where(sql)

    elsif params.dig(:filters, :start_date).present?
      start_date = DateTime.strptime(params.dig(:filters, :start_date), "%Y-%m-%d").in_time_zone("Pacific Time (US & Canada)").beginning_of_day
      end_date = DateTime.strptime(params.dig(:filters, :end_date).presence || Date.today, "%Y-%m-%d").in_time_zone("Pacific Time (US & Canada)").end_of_day
      deals = deals.where("created_at >= ? AND created_at <= ?", start_date, end_date )
    else
      deals = deals.where("created_at >= ?", Date.today.in_time_zone("Pacific Time (US & Canada)").beginning_of_day)
    end

    if params.dig(:filters, :query).present?
      deals = deals.where("client_last_name ILIKE ? OR stock_number ILIKE ?", "%#{params.dig(:filters, :query)}%", "%#{params.dig(:filters, :query)}%")
    end

    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        deals = deals.order(k => v)
      end
    end

    @deals = deals
    @grouped_deals = deals.group_by{|d| d.created_at.in_time_zone("Pacific Time (US & Canada)").beginning_of_day}.sort_by{|k, v| k}.to_h
  end


  def stored_deals
    @deals = current_user.dealership.deals.where(stored: true)
  end

  def new_vehicle_report
    @deals = current_user.dealership.deals.where(is_used: false).where("created_at > ?", current_user.dealership.custom_mtd_start_date)
    @grouped_deals = @deals.group_by{|d| d.model}.sort_by{ |k, v| v.count }.to_h
  end

  def used_vehicle_report
    @deals = current_user.dealership.deals.where(is_used: true).where("created_at > ?", Date.today.beginning_of_month)
    @grouped_deals = @deals.group_by{|d| d.created_at.in_time_zone("Pacific Time (US & Canada)").beginning_of_day}.sort_by{|k, v| k}.to_h
  end

end