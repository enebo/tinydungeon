require 'wreckem/component'

ContainedBy = Wreckem::Component::define(:entity)
Containee = Wreckem::Component::define(:entity)
Description = Wreckem::Component.define(:string)
Echo = Wreckem::Component.define
Entry = Wreckem::Component.define
Container = Wreckem::Component.define
LastContainedBy = Wreckem::Component::define(:entity)
Link = Wreckem::Component.define
LinkRef = Wreckem::Component.define(:entity)
Name = Wreckem::Component.define(:string)
NameAlias = Wreckem::Component.define(:string)
NPC = Wreckem::Component.define
Player = Wreckem::Component.define

require 'tinydungeon/components/command_line'
require 'tinydungeon/components/message'
require 'tinydungeon/components/namedb'
