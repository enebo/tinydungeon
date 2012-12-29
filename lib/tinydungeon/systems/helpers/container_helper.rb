require 'tinydungeon/game_components'

module ContainerHelper
  ##
  # Add an entity to a container entity
  def add_to_container(container, entity)
    manager.transaction do
      must_be_container(container)
      entity.has ContainedBy.new(container)
      container.add Containee.new(entity)
    end
  end

  def swap_containers(old_container, new_container, entity)
    manager.transaction do
      must_be_container(new_container)
      old_container.many(Containee).each { |l| l.delete if l.same? entity.id }
      entity.one(ContainedBy).value = new_container.id
      new_container.add Containee.new(entity)
    end
  end

  def container?(entity)
    entity.is? Container
  end

  def each_container_entity(container)
    must_be_container(container)
    container.many(Containee).each { |l| yield manager[l] }
  end

  def container_for(entity)
    manager[entity.one(ContainedBy)]
  end

  def must_be_container(entity)
    unless entity.is? Container
      raise "Not a container #{manager.entity_as_string(entity)}"
    end
  end
end
