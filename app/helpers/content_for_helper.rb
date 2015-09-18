module ContentForHelper
  def set_title(title)
    content_for(:title, title)
  end

  def get_menu_link(name, url)
    link_class = ""
    link_class = "current" if name == content_for(:title)

    return link_to name, url, class: link_class
  end
end