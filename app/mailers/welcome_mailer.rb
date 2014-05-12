class WelcomeMailer < ActionMailer::Base
  SENDER = "welcome@pnpi.herokuapp.com"
  SUBJECT = "Welcome to the Philadelphia New Play Initiative!"
  
  default from: SENDER
  
  def welcome_email(person)
    @person = person
    @signup_link = new_user_registration_url @person, @person.signup_token
    mail to: @person.email, subject: SUBJECT
  end
  
end
