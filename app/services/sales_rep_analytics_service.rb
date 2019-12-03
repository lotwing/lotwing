class SalesRepAnalyticsService

  def initialize(user, ending_month_override: nil)
    @user = user

    @chart_data_month_counts_by_day = []
  end

  def combined_deals_by_month
    @combined_deals_by_month ||= sales_rep_deals_grouped_by_month.merge(split_rep_deals_grouped_by_month){ |k, a_value, b_value| a_value + b_value }.sort.to_h
  end

  def combined_deals_by_day
    @combined_deals_by_day ||= current_month_sales_deals_by_day.merge(current_month_split_deals_by_day){ |k, a_value, b_value| a_value + b_value }.sort.to_h
  end

  def chart_data_month_counts_by_day
    arr = []
    sum = 0
    deals_created_by_day = combined_deals_by_day.map{|k, v| [k.day, v]}.to_h

    days_this_month.each do |i|
      deals_created_that_day = deals_created_by_day[i]

      arr << (sum += (deals_created_that_day || 0) )
    end 

    return arr
  end
  #creates an array like [1,2,2,2,3,3,3,4] incrementally increasing the sum until length = days this month  

  def chart_monthly_counts_by_day
    arr = []
    
    a = *(1..day_at_the_end_of_the_month)
    
    a.each do |i|
      arr << rolling_monthly_average_value.to_f / (day_at_the_end_of_the_month.to_f / (i))
    end

    return arr
  end
  #creates an array of linear deal counts per day (this month) ending up at the 3 month average

  def rolling_monthly_average_value
    return 0 if combined_deals_by_month.length.zero?
    
    ((combined_deals_by_month.map{|k, v| v}.sum.to_f) / (combined_deals_by_month.length)).round(0)
  end
  #in the last 3 months, what is the average count

  def above_moving_average?
    delta = chart_data_month_counts_by_day[day_at_today - 1] - chart_monthly_counts_by_day[day_at_today - 1]
    #todays deal counts minus linear value for today, positive means you are above average

    return delta > 0
  end
  #returns whether or not this sales rep is above their monthly linear trend line by day, for todays date

  private
    def day_at_the_end_of_the_month
      Date.current.end_of_month.day
    end

    def days_this_month
      (1..day_at_today)
    end

    def day_at_today
      Date.current.day
    end

    def beginning_of_month
      Date.current.beginning_of_month
    end

    def three_months_ago_beginning_of_month
      beginning_of_month - 3.months
    end


    def sales_rep_deals_grouped_by_month 
      Deal
        .where(sales_rep_id: @user.id)
        .where("created_at >= ? and created_at < ?", three_months_ago_beginning_of_month, beginning_of_month)
        .group("date_trunc('month', created_at) ")
        .count
    end

    def split_rep_deals_grouped_by_month 
      Deal
        .where(split_rep_id: @user.id)
        .where("created_at >= ? and created_at < ?", three_months_ago_beginning_of_month, beginning_of_month)
        .group("date_trunc('month', created_at) ")
        .count.map{|k, v| [k, v.to_f/2]}.to_h  
    end

    def current_month_sales_deals_by_day 
      Deal
        .where(sales_rep_id: @user.id)
        .where("created_at >= ?", beginning_of_month)
        .group("date_trunc('day', created_at) ")
        .count
    end

    def current_month_split_deals_by_day
      Deal
        .where(split_rep_id: @user.id)
        .where("created_at >= ?", beginning_of_month)
        .group("date_trunc('day', created_at) ")
        .count.map{|k, v| [k, v.to_f/2]}.to_h
    end


end