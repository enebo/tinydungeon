require 'tinydungeon/game_components'

module ContainerHelper
  ##
  # Add an entity to a container entity
  def add_to_container(container, entity)
    must_be_container(container)
    entity.has ContainedBy.new(container)
    container.add Containee.new(entity)
  end

  def swap_containers(old_container, new_container, entity)
    must_be_container(new_container)
    old_container.many(Containee).each { |l| l.delete if l.same? entity.id }
    entity.one(ContainedBy).update!(new_container.id)
    new_container.add Containee.new(entity)
  end

  def container?(entity)
    entity.is? Container
  end

  def each_container_entity(container)
    must_be_container(container)
    container.many(Containee).each { |l| yield l.to_entity }
  end

  def container_for(entity)
    entity.one(ContainedBy).to_entity
  end

  def must_be_container(entity)
    unless entity.is? Container
      raise "Not a container #{entity.as_string}"
    end
  end
end
