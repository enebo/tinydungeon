require 'tinydungeon/systems/commands/command'

class SaveCommand < Command
  def execute(cmd)
    manager.save
    output_you cmd.entity, "World Saved."
    output_others cmd.entity, "#{cmd.entity.one(Name)} saved world."
  end

  def description
    "Save game state to a file"
  end

  def usage
    "@save {filename}"
  end
end
