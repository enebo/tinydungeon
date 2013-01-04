require 'wreckem/component'

# You can set a starting room via /bind
BindRoom = Wreckem::Component::define_as_ref
# Link to the container the item is contained within
ContainedBy = Wreckem::Component::define_as_ref
# Represents command input (generally from players)
CommandLine = Wreckem::Component.define_as_string
# Containers as have n of these links for each thing it contains
Containee = Wreckem::Component::define_as_ref
# Object description
Description = Wreckem::Component.define_as_string
# Things which have this can echo
Echo = Wreckem::Component.define
# The main place where players enter is not BindRoom set
Entry = Wreckem::Component.define
# Marker to indicate something is a container
Container = Wreckem::Component.define
# Link marker (only used as identifier if you want to update all links)
Link = Wreckem::Component.define
# Where the link entity is
LinkRef = Wreckem::Component.define_as_ref
# Name of an object
Name = Wreckem::Component.define_as_string
# Alias for a link (possibly other things)
NameAlias = Wreckem::Component.define_as_string
# Is this player online
Online = Wreckem::Component.define
# Who owns this object
Owner = Wreckem::Component.define_as_ref
# Is this an NPC
NPC = Wreckem::Component.define
# An ordinary item (!Room,Player,NPC,{unlinkedobject})
NormalObject = Wreckem::Component.define
# This is a connected player character
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

