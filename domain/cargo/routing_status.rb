# Describes status of cargo routing
class RoutingStatus < Enum
    NotRouted
    Misrouted
    Routed
    
  # RoutingStatusValues = { 
  #             0 => :NotRouted,
  #             1 => :Misrouted,
  #             2 => :Routed
  #           }
end
