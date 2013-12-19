Warden::Strategies.add(:email_authenticatable) do
  def authenticate!
    email = params[:user][:email]        if params[:user]
    password = params[:user][:password]  if params[:user]
    person = Person.find_by_email(email) if email
    user = User.find_by_person(person)   if person
    
    if    email.nil?                     then fail! "No email address provided."
    elsif password.nil?                  then fail! "No password provided."
    elsif person.nil?                    then fail! "User with email #{email} could not be found."
    elsif user.nil?                      then fail! "User with email #{email} has not registered yet."
    elsif !user.valid_password? password then fail! "Invalid password for email #{email}."
    else                                      success! user
    end
    
  end
  
  def valid?
    true
  end
  
end