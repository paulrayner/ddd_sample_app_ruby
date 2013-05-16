require 'curator'
class Note
  include Curator::Model
  attr_accessor :id, :title, :description, :user_id
end