module NameHelper
  def name_to_object_info(issuer, name)
    if name == "here"
      entity = container_for(issuer)
      name = entity.one(Name)
      num = namedb.name_map[name]
    elsif name == "me"
      entity = issuer
      name = entity.one(Name)
      num = namedb.name_map[name]
    elsif name =~ /^\d+$/
      num = name.to_i
      entity = manager[namedb.num_map[num]]
      name = entity.one(Name)
    else
      num = namedb.name_map[name]
      entity = manager[namedb.num_map[num]]
    end
    [name, num, entity]
  end

  def namedb
    system.namedb
  end
end
