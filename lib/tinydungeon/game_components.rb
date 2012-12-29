require 'wreckem/component'

ContainedBy = Wreckem::Component::define_as_ref
CommandLine = Wreckem::Component.define_as_string
Containee = Wreckem::Component::define_as_ref
Description = Wreckem::Component.define_as_string
Echo = Wreckem::Component.define
Entry = Wreckem::Component.define
Container = Wreckem::Component.define
LastContainedBy = Wreckem::Component::define_as_ref
Link = Wreckem::Component.define
LinkRef = Wreckem::Component.define_as_ref
Name = Wreckem::Component.define_as_string
NameAlias = Wreckem::Component.define_as_string
Owner = Wreckem::Component.define_as_ref
NPC = Wreckem::Component.define
# An ordinary item (!Room,Player,NPC,{unlinkedobject})
NormalObject = Wreckem::Component.define
Player = Wreckem::Component.define
# A reference to a message
MessageRef = Wreckem::Component.define_as_ref
# The type of message and the string sent
SayMessage = Wreckem::Component.define_as_string
# Output which is not a person talking
OutputMessage = Wreckem::Component.define_as_string
# When something happened (like when a message was sent)
Timestamp = Wreckem::Component.define_as_int
# Who sent something (like a message)
Sender = Wreckem::Component.define_as_ref
