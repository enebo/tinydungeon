require 'tinydungeon/systems/commands/command'

class SaveCommand < Command
  def execute(cmd)
    manager.save
    puts "World Saved."
  end

  def description
    "Save game state to a file"
  end

  def usage
    "@save {filename}"
  end
end
