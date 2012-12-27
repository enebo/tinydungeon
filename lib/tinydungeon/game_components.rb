require 'wreckem/component'

ContainedBy = Wreckem::Component::define(:entity)
CommandLine = Wreckem::Component.define(:string)
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
SayMessage = Wreckem::Component.define(:string)

require 'tinydungeon/components/message'
require 'tinydungeon/components/namedb'
