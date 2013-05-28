class TransportStatus

  # Describes status of cargo transportation
  
  TransportStatusValues = { 
              0 => :NotReceived,
              1 => :OnboardCarrier,
              2 => :InPort,
              3 => :Claimed,
              4 => :Unknown
            }

  # TODO Figure out how to implement this enum in Ruby, and its type extensions

end
