module ApplicationHelper
  def link_to_index(model, text = nil)
    if current_user.can_read? model.class
      text ||= "View all #{model.class.name.pluralize}"
      path = send("#{model.class.name.downcase.pluralize}_path")
      link_to text, path, class: 'btn'
    end
  end

  def link_to_show(model, text = nil)
    if current_user.can_read? model.class
      text ||= model
      link_to text, model
    end
  end

  def link_to_new(model, text = "New")
    if current_user.can_create? model.class
      path = send("new_#{model.class.name.downcase}_path")
      link_to text, path, class: 'btn btn-primary'
    end
  end

  def link_to_edit(model, text = "Edit")
    if current_user.can_update? model.class
      path = send("edit_#{model.class.name.downcase}_path", model)
      link_to text, path, class: 'btn btn-mini'
    end
  end

  def link_to_destroy(model, text = "Delete", confirm = "Are you sure?")
    if current_user.can_delete? model.class
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

  def header_for_index(model_array)
    header_for model_array.first.class.name.pluralize
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
end
