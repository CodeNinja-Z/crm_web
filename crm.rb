require_relative 'contact.rb'
require_relative 'rolodex.rb'
require 'sinatra'

# In this assignment, rolodex class serves as Model in MVC
$rolodex = Rolodex.new # Set a global variable to allow acces from each action in Sinatra

# temp fake data
$rolodex.add_contact(Contact.new("Johnny", "Bravo", "johnny@bitmakerlabs.com", "Rockstar"))
$rolodex.add_contact(Contact.new("Cornholio", "Great", "bungmuch@bitmakerlabs.com", "From Lake Titticaca"))
$rolodex.add_contact(Contact.new("Rodney", "Johnson", "DG@bitmakerlabs.com", "Shower cap tester"))

get '/' do
  @crm_app_name = "My CRM"
  erb :index
end

get '/contacts' do
  erb :contacts
end

get '/contacts/new' do
  erb :new_contact
  # erb :new_contact, layout: minimal  # How to use another layout instead of using layout.erb
end

get '/contacts/:id' do
  # want to display a contact, need to find it first
  @contact_to_display = $rolodex.find_contact_by_id(params[:id].to_i)
  if @contact_to_display
    erb :show_contact
  else
    raise Sinatra::NotFound  # Sinatra 404 page, "Sinatra doesn't know this ditty"
  end
end

post '/contacts' do
  new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:notes])
  $rolodex.add_contact(new_contact)
  redirect to('/contacts')  # redirect to get '/contacts', 
                            # redirect to goes to get '/contacts' by default
end

get "/contacts/:id/edit" do
  # want to edit a contact, need to find it first
  @contact_to_update = $rolodex.find_contact_by_id(params[:id].to_i)
  if @contact_to_update
    erb :edit_contact
  else
    raise Sinatra::NotFound  # Sinatra 404 page, "Sinatra doesn't know this ditty"
  end
end

put "/contacts/:id" do
  # Below line has two functions: 
  # 1. To get the contact to be updated by id
  #    Since .erb (View) can only pass back params[] (array of hashes). It can't pass
  #    an instance variable, such as @contact_to_update, to crm.rb (Controller).
  #    So we need to get the contact object first.
  # 2. For security checking
  #    If you modify a user's info and later database(is rolodex in this case) somehow 
  #    crushes, you won't find this contact therefore raising a NotFound error. 
  #    This is a traditional way of data existence checking.
  contact_to_update = $rolodex.find_contact_by_id(params[:id].to_i)
  if contact_to_update
    contact_to_update.first_name = params[:first_name]
    contact_to_update.last_name = params[:last_name]
    contact_to_update.email = params[:email]
    contact_to_update.notes = params[:notes]
    redirect to("/contacts")
  else
    raise Sinatra::NotFound  # Sinatra 404 page, "Sinatra doesn't know this ditty"
  end
end

delete "/contacts/:id" do
  # want to delete a contact, need to find it first
  @contact_to_delete = $rolodex.find_contact_by_id(params[:id].to_i)
  if @contact_to_delete
    $rolodex.delete_contact(@contact_to_delete)
    redirect to("/contacts")
  else
    raise Sinatra::NotFound  # Sinatra 404 page, "Sinatra doesn't know this ditty"
  end
end

# Controller can pass an instance varibale to View, but View can't pass an instance
# variable to Controller.
# View can only store values in input fields and values in url in params[] and pass
# it to Controller

get '/display_an_attribute' do
  erb :display_an_attribute
end
