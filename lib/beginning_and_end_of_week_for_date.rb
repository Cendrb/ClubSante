class Date
  def get_beginning_of_week
    return self - (self.wday - 1).days
  end
  def get_end_of_week
    return self.get_beginning_of_week + 6.days
  end
end