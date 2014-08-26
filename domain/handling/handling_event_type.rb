require 'enum'

class HandlingEventType
  include MyEnum

  define :Load, "Load"
  define :Unload, "Unload"
  define :Receive, "Receive"
  define :Claim, "Claim"
  define :Customs, "Customs"
end
