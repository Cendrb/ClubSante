module BoolHelper
  def b_to_s(bool, upper = false)
    if bool
      if upper
        return "Ano"
      else
        return "ano"
      end
    else
      if upper
        return "Ne"
      else
        return "ne"
      end
    end
  end
end