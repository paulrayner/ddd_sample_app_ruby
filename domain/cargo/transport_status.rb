require 'enum'

# Describes status of cargo transportation
class TransportStatus
  include MyEnum

  define :NotReceived, "Not Received"
  define :OnboardCarrier, "Onboard Carrier"
  define :InPort, "In Port"
  define :Claimed, "Claimed"
  define :Unknown, "Unknown"
end
