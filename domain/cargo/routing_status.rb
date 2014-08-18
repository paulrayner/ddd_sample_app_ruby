require 'enum'

# Describes status of cargo routing
class RoutingStatus < Enum
  NotRouted
  Misrouted
  Routed
end
