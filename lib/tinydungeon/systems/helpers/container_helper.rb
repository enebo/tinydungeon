require 'tinydungeon/game_components'

module ContainerHelper
  ##
  # Add an entity to a container entity
  def add_to_container(container, entity)
    must_be_container(container)
    entity.has ContainedBy.new(container.uuid)
    container.add Containee.new(entity.uuid)
  end

  def swap_containers(old_container, new_container, entity)
    must_be_container(new_container)
    old_container.many(Containee).each { |l| l.delete if l.same? entity.uuid }
    entity.one(ContainedBy).value = new_container.uuid
    new_container.add Containee.new(entity.uuid)
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
