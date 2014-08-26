require 'enum'

# Describes status of cargo routing
class RoutingStatus
  include MyEnum

  define :NotRouted, 'Not Routed'
  define :Misrouted, 'Misrouted'
  define :Routed, 'Routed'
end
