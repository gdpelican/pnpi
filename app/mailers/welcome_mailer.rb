class WelcomeMailer < ActionMailer::Base
  default from: "welcome@pnpi.herokuapp.com"
  
  def welcome_email(person)
    @person = person
    mail(to: @person.email, subject: 'You\'ve been accepted as part of the Philadelphia New Play Initiative!')
  end
end
