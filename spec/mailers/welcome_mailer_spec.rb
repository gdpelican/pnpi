require 'spec_helper'

describe WelcomeMailer do
  
  let(:person) { create :person }
  let(:mail) { WelcomeMailer.welcome_email person }
  
  it "sends to the correct email address" do
    mail.to.should eq [person.email]
  end
  
  it "has the correct subject" do
    mail.subject.should eq WelcomeMailer::SUBJECT
  end
  
  it "is sent from the correct address" do
    mail.from.should eq [WelcomeMailer::SENDER]
  end
  
  it "has the correct signup_link" do
    mail.body.encoded.should include new_user_registration_url(person, person.signup_token)
  end
  
end
