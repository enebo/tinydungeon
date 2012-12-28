require 'wreckem/component'

ContainedBy = Wreckem::Component::define(:ref)
CommandLine = Wreckem::Component.define(:string)
Containee = Wreckem::Component::define(:ref)
Description = Wreckem::Component.define(:string)
Echo = Wreckem::Component.define
Entry = Wreckem::Component.define
Container = Wreckem::Component.define
LastContainedBy = Wreckem::Component::define(:ref)
Link = Wreckem::Component.define
LinkRef = Wreckem::Component.define(:ref)
Name = Wreckem::Component.define(:string)
NameAlias = Wreckem::Component.define(:string)
NPC = Wreckem::Component.define
Num = Wreckem::Component.define(:int)
# An ordinary item (!Room,Player,NPC,{unlinkedobject})
NormalObject = Wreckem::Component.define
Player = Wreckem::Component.define
# A reference to a message
MessageRef = Wreckem::Component.define(:ref)
# The type of message and the string sent
SayMessage = Wreckem::Component.define(:string)
# Output which is not a person talking
OutputMessage = Wreckem::Component.define(:string)
# When something happened (like when a message was sent)
Timestamp = Wreckem::Component.define(:int)
# Who sent something (like a message)
Sender = Wreckem::Component.define(:ref)

require 'tinydungeon/components/namedb'
