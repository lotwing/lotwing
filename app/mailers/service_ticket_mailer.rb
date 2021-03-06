class ServiceTicketMailer < ActionMailer::Base
  default :from => "Lotwing Admin <admin@lotwing.herokuapp.com>"

  def self.notify_about_service_ticket_created(service_ticket_department)
    @service_ticket_department = service_ticket_department
    @service_ticket = @service_ticket_department.service_ticket

    department_email = @service_ticket_department.name + "_email"

    recipients = @service_ticket
                  .dealership
                  .users
                  .active
                  .joins(:email_preference)
                  .where(email_preferences: {department_email => true})
                  .pluck(:email)
                  .uniq

    recipients.each do |email|
      ServiceTicketMailer.new_service_ticket_created(@service_ticket, email.strip).deliver
    end

  end

  def new_service_ticket_created(service_ticket, email)
    @service_ticket = service_ticket
    @email = email

    mail( to: @email, subject: "Vehicle #{@service_ticket.stock_number} has a new service ticket." )
  end

end