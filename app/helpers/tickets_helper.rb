module TicketsHelper
  def get_ticket_entries_remaining_string(ticket)
    if ticket.entries_remaining == -1
      return "není omezena vstupy"
    else
      return ticket.entries_remaining
    end
  end
  
  def get_ticket_end_date(ticket)
    if ticket.activated_on == nil
      return "ještě nebyla aktivována"
    else
      return l((ticket.activated_on + ticket.time_restriction), format: :date)
    end
  end
  
  def get_ticket_therapies_string(ticket)
    if ticket.therapy_category.therapies.count > 0
      return "#{ticket.therapy_category.name}  (#{ticket.therapy_category.therapies.pluck(:name).join(", ").downcase})"
    else
      return ticket.therapy_category.name
    end
  end
end