module ApplicationHelper

  def navbar_tab_to(label, link_path)
    css_class = current_page?(link_path) ? "active" : "inactive"
    content_tag(:li, :class => css_class) do
      link_to label, link_path
    end
  end

  def sortable(column, label = nil)
    label ||= column.titleize
    css_class = (column == sort_by) ? "current #{sort_in}" : nil
    direction = (column == sort_by && sort_in == "asc") ? "desc" : "asc"
    link_to label, {:sort_by => column, :sort_in => sort_in}, {:class => css_class}
  end

end
