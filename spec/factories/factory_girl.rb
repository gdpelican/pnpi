FactoryGirl.define do
  factory :person do
    first_name 'test'
    last_name 'person'
    email 'test@email.com'
    website 'www.example.com'
    phone '555 555 5555'
  end
  
  factory :place do
    address '555 Any Street, Springfield, USA'
  end
  
  factory :thing do
    price '5.00'
    period 'week'
  end
  
  factory :sample do
    picture File.open 'public/images/missing_person.png'
  end
  
  trait :resource do
    name 'test name'
    preview 'preview'
    description 'description'  
  end
  
  factory :tag do
    name 'test tag'
    association :tag_type
  end
  
  factory :tag_type do
    name 'test type'
  end
  
end