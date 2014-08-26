require 'ruby-enum'

# Describes status of cargo routing
class RoutingStatus
  include Ruby::Enum

  define :NotRouted, 'Not Routed'
  define :Misrouted, 'Misrouted'
  define :Routed, 'Routed'
end
