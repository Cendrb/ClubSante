module DateHelper
  def get_beginning_of_week(date)
    our_wday = date.wday == 0 ? 6 : date.wday - 1
    return date - (our_wday).days
  end

  def get_end_of_week(date)
    our_wday = date.wday == 0 ? 6 : date.wday - 1
    return date - (6 - our_wday).days
  end
end