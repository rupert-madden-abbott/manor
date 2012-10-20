module ApplicationHelper
  def link_to_index(model, text = nil)
    if can? :read, model
      text ||= "View all #{model.class.name.pluralize}"
      path = send("#{model.class.name.downcase.pluralize}_path")
      link_to text, path, class: 'btn'
    end
  end

  def link_to_edit(model, text = "Edit")
    if can? :update, model
      path = send("edit_#{model.class.name.downcase}_path", model)
      link_to text, path, class: 'btn btn-mini'
    end
  end

  def link_to_destroy(model, text = "Delete", confirm = "Are you sure?")
    if can? :destroy, model
      path = send("#{model.class.name.downcase}_path", model)
      klass = 'btn btn-danger btn-mini'
      link_to text, path, method: :delete, confirm: confirm, class: klass
    end
  end

  def header_for(title)
    content_tag(:div, class: "page-header") do
      content_tag(:h1, title)
    end
  end

  def header_for_index(model_class)
    header_for model_class.name.pluralize
  end

  def header_for_show(model)
    header_for model
  end

  def header_for_new(model)
    header_for "New #{model.class.name}"
  end

  def header_for_edit(model)
    header_for "Edit #{model}"
  end

  def filtered?
    params[:filters].present?
  end

  def filtered_by?(filter)
    Array.wrap(params[:filters]).include? filter.to_s
  end

  def filters
    Array.wrap(params[:filters]).join(", ")
  end

  def filter_link_for(model_class, filter)
    if filtered_by?(filter)
      content_tag(:li, class: "active") do
        link_to filter.to_s.titleize, send("#{model_class.table_name}_path")
      end
    else
      content_tag(:li) do
        link_to filter.to_s.titleize, send("#{model_class.table_name}_path",
            filters: :archived)
      end
    end
  end

  def filter_dropdown_menu_for(model_class, *filters)
    content_tag(:ul, class: "dropdown-menu") do
      filters.collect do |filter|
        filter_link_for(model_class, filter)
      end.join("").html_safe
    end
  end

  def filter_dropdown_for(model_class, *filters)
    content_tag(:li, class: filtered? ? "active dropdown" : "dropdown") do
      content_tag(:a, class: "dropdown-toggle", data: { toggle: "dropdown" },
        href: "#") do
          ("Filter" + content_tag(:strong, '', class: "caret")).html_safe
      end +
      filter_dropdown_menu_for(model_class, *filters)
    end
  end

  def bootstrap_form_for(record, &block)
    simple_form_for(record, validate: true, html: { 'class' => 'form-horizontal' }, &block)
  end
end
