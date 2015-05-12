module DateHelper
  def get_beginning_of_week(date)
    return date - (date.wday - 1).days
  end

  def get_end_of_week(date)
    return get_beginning_of_week(date) + 6.days
  end
end