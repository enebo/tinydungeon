module NameHelper
  def name_to_object_info(issuer, name)
    if name == "here"
      entity = container_for(issuer)
      name, num = entity.one(Name), entity.id
    elsif name == "me"
      entity = issuer
      name, num = entity.one(Name), entity.id
    elsif name =~ /^\d+$/
      num = name.to_i
      entity = Wreckem::Entity.find(num)
      name = entity.one(Name)
    else
      name_comp = Name.all.find { |n| n.same? name }
      entity = name_comp.entity
      num = entity.id
    end
    [name, num, entity]
  end
end
