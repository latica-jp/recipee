module ApplicationHelper

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger",
      alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |flash_type, message|
      concat(
        content_tag(:div, message, class: "alert alert-dismissable #{bootstrap_class_for(flash_type)} fade in") do
          concat(
            content_tag(:button, class: "close", data: { dismiss: "alert" }) do
              concat content_tag(:span, "&times;".html_safe)
            end
          )
          concat message
        end
      )
    end
  end

  def link_to_add_field(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for association, new_object, child_index: id do |builder|
      render "#{association.to_s.singularize}_form", f: builder
    end
    link_to '#', class: "btn btn-success add_field",
      data: {id: id, fields: fields.gsub('\n', '')} do
      content_tag(:i, "", class: "glyphicon glyphicon-plus").html_safe + " " + name
    end

  end

  def link_to_remove_field(name, f)
    f.hidden_field(:_destroy) + link_to(name, "#", class: "btn btn-default remove_field")
  end

  def get_name_from_email email
    email =~ /(^.*)@.*$/
    $1 ? $1 : email
  end
end
