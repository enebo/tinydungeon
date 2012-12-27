require 'tinydungeon/game_components'

module ContainerHelper
  ##
  # Add an entity to a container entity
  def add_to_container(container, entity)
    unless container.is? Container
      raise "Not a container #{manager.entity_as_string(container)}"
    end

    entity.has ContainedBy.new(container.uuid)
    container.add Containee.new(entity.uuid)
  end

  def remove_from_container(container, entity)
  end
end
