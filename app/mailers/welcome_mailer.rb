class WelcomeMailer < ActionMailer::Base
  default from: "welcome@pnpi.herokuapp.com"
  
  def welcome_email(person)
    @person = person
    @signup_link = new_user_registration_path @person, @person.signup_token
    mail(to: @person.email, subject: 'Welcome to the Philadelphia New Play Initiative!')
  end
end
