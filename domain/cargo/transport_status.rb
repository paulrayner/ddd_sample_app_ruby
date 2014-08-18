require 'enum'

# Describes status of cargo transportation
class TransportStatus < Enum
  NotReceived
  OnboardCarrier
  InPort
  Claimed
  Unknown
end
