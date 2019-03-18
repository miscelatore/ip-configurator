module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
  
  def show_flag_enable_disable(param)
    if param
      content_tag(:span, "", class: ["glyphicon", "glyphicon-ok"], style: "color:green; font-size: 1em;", aria: "true" )
    else
      content_tag(:span, "", class: ["glyphicon", "glyphicon-ban-circle"], style: "color:red; font-size: 1em;", aria: "true" )
    end
  end
  
  def show_flag_reserved(param)
    if param
      content_tag(:span, "", class: ["glyphicon", "glyphicon-ok"], style: "color:green; font-size: 1em;", aria: "true" )
      #else
      #content_tag(:span, "", class: ["glyphicon", "glyphicon-remove"], style: "color:red; font-size: 1em;", aria: "true" )
    end
  end
end
