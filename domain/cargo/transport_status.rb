require 'ruby-enum'

# Describes status of cargo transportation
class TransportStatus
  include Ruby::Enum

  define :NotReceived, 'Not Received'
  define :OnboardCarrier, 'Onboard Carrier'
  define :InPort, 'In Port'
  define :Claimed, 'Claimed'
  define :Unknown, 'Unknown'
end
