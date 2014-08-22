require 'enum'

class HandlingEventType < Enum
  Load
  Unload
  Receive
  Claim
  Customs
end
