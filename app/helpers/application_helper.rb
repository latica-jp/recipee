module ApplicationHelper

  # https://gist.github.com/roberto/3344628
  def bootstrap_class_for flash_type
    case flash_type
      when "success"
        "alert-success"
      when "error"
        "alert-danger"
      when "alert"
        "alert-warning"
      when "notice"
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def link_to_add_field(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for association, new_object, child_index: id do |builder|
      render "#{association.to_s.singularize}_form", f: builder
    end
    link_to name, '#', class: "btn btn-default add_field", data: {id: id, fields: fields.gsub('\n', '')}
  end
  
  def link_to_remove_field(name, f)
    f.hidden_field(:_destroy) + link_to(name, "#", class: "btn btn-default remove_field")
  end
end
