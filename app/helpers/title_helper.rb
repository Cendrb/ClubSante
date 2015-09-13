module TitleHelper
  def set_title(title)
    content_for(:title, title)
  end
end