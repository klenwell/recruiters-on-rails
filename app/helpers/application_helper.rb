module ApplicationHelper

  def navbar_tab_to(label, link_path)
    css_class = current_page?(link_path) ? "active" : "inactive"
    content_tag(:li, :class => css_class) do
      link_to label, link_path
    end
  end

  def sortable(column, label = nil)
    is_active_column = column == sort_by

    label ||= column.titleize
    css_class = (is_active_column) ? "current #{sort_in}" : nil
    direction = 'asc'

    icon_span = '<span class="glyphicon %s" aria-hidden="true"></span>'
    glyphicon = 'glyphicon glyphicon-sort'

    if is_active_column
      chevron = (sort_in == 'asc') ? 'up' : 'down'
      glyphicon = format('glyphicon-chevron-%s', chevron)
      direction = (sort_in == "asc") ? "desc" : "asc"
    end

    icon = format(icon_span, glyphicon)
    label = format('%s %s', icon, label)
    link_to label.html_safe, {:sort_by => column, :sort_in => direction}, {:class => css_class}
  end

end
