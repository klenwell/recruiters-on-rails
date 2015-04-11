module ApplicationHelper

  def navbar_tab_to(label, link_path)
    css_class = current_page?(link_path) ? "active" : "inactive"
    content_tag(:li, :class => css_class) do
      link_to label, link_path
    end
  end

end
