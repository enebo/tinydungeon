require 'wreckem/component'

Player = Wreckem::Component.define
NPC = Wreckem::Component.define
Echo = Wreckem::Component.define
Entry = Wreckem::Component.define
Container = Wreckem::Component.define

require 'tinydungeon/components/command_line'
require 'tinydungeon/components/contained_by'
require 'tinydungeon/components/containee'
require 'tinydungeon/components/description'
require 'tinydungeon/components/last_contained_by'
require 'tinydungeon/components/name'
require 'tinydungeon/components/namedb'
