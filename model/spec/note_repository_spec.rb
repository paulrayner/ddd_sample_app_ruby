require 'spec_helper'
require 'rspec'
require 'date'
require 'pry'
require "#{File.dirname(__FILE__)}/../cargo/note"
require "#{File.dirname(__FILE__)}/../cargo/note_repository"

describe "NoteRepository" do
# TODO Move this into infrastructure specs file
  it "Note can be persisted" do
    # binding.pry
    note = Note.new(:title => "some_name", 
                    :description => "This is the description", 
                    :user_id => 1)

    NoteRepository.save(note)

    @notes = NoteRepository.find_by_title("some_name")
    @notes.size.should == 1
    @notes.first.title.should == "some_name"
    @notes.first.description.should == "This is the description"
  end
end