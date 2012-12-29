module NameHelper
  def name_to_object_info(issuer, name)
    if name == "here"
      entity = container_for(issuer)
      name = entity.one(Name)
      num = manager[name]
    elsif name == "me"
      entity = issuer
      name = entity.one(Name)
      num = manager[name]
    elsif name =~ /^\d+$/
      num = name.to_i
      name = entity.one(Name)
      entity = manager[num]
    else
      name = entity.one(Name)
      entity = manager[name]
    end
    [name, num, entity]
  end
end
