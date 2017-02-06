class ContactsController < ApplicationController
  
  # GET request to/contact-us
  # show contact form  
  def new
    # mass assignment of formfeilds into Contact objects
    @contact = Contact.new
  end
  # POST request /contacts
  def create
    # Mass assignment of form feilds into contact object
    @contact = Contact.new(contact_params)
    # Save the contact object to the database
    if @contact.save
      # Store form feilds via parameters, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into Contact mailer email method
      ContactMailer.contact_email(name, email, body).deliver
      # Store success message in flash hash
      # and direct into new action
      flash[:success] = "message sent!"
      redirect_to new_contact_path, notice: "Message sent."
    else 
      flash[:danger] = @contact.errors.full_messages.join(", ")
      # If contact subject doesnt save,
      # store errors in flash hash,
      # and redirect to new action
      redirect_to new_contact_path
    end
  end

  private 
  # To collect data from a form, we need to use 
  # strong parameters and whitelist form feilds
  def contact_params
    params.require(:contact).permit(:name, :email, :comments)
  end
end

