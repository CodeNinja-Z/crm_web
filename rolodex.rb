require_relative 'contact.rb'

class Rolodex
  attr_accessor :contacts, :found, :first_names, :last_names, :emails, :notes
  @@id = 1000

  def initialize
    @contacts = []
  end

  def add_contact(contact)
    contact.id = @@id
    @contacts << contact
    @@id += 1
  end

  # alternative of find contact, use method '.find'
  def find_contact_by_id(id)
     @contacts.each do |contact|
        if id == contact.id
          @found = true
          return contact
       end
     end
     @found = false
     # puts "There is no record for ID: #{id}"
  end

  def delete_contact(contact)
    @contacts.delete(contact)
  end
end