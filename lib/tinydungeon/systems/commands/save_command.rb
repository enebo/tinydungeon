require 'tinydungeon/systems/commands/command'

class SaveCommand < Command
  def execute(cmd)
    manager.save
    say_to_player cmd.entity, "World Saved."
  end

  def description
    "Save game state to a file"
  end

  def usage
    "@save {filename}"
  end
end
