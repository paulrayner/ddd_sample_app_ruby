require 'ruby-enum'

class HandlingEventType
  include Ruby::Enum

  define :Load, 'Load'
  define :Unload, 'Unload'
  define :Receive, 'Receive'
  define :Claim, 'Claim'
  define :Customs, 'Customs'
end
