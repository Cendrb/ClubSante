module CalendarRenderingHelper
  def render_modified_box(modification)
    if modification.differs_from_template?
      return "<div class=\"calendar_modified_box\"> </div>".html_safe
    end
  end
end