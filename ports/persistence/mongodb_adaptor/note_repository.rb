require 'curator'
class NoteRepository
  include Curator::Repository

  indexed_fields :user_id, :title
end