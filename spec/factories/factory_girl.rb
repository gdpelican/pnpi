FactoryGirl.define do
  factory :person do
    first_name 'test'
    last_name 'person'
    email 'test@email.com'
    website 'www.example.com'
    phone '555 555 5555'
    resource
  end
  
  factory :user do
    password 'password'
  end
  
  factory :place do
    address '555 Any Street, Springfield, USA'
    resource
  end
  
  factory :thing do
    price '5.00'
    period 'week'
    resource
  end
  
  factory :sample do
    picture File.open 'public/images/missing_person.png'
  end
  
  sequence(:name) { |n| 'test name #{n}' }
  trait :resource do
    name
    preview 'preview'
    description 'description'
    active true
  end
  
  factory :job  
  factory :event
  factory :price
  
  factory :tag do
    name 'test tag'
    association :tag_type
  end
  
  factory :tag_type do
    name 'test type'
  end
  
  factory :search do
    
  end
  
  trait :filter do
    type 'filter'
    resource 'Person'
  end
  
  trait :text do
    type 'text'
    term '5'
  end
  
  trait :category do
    type 'categories'
  end
  
  trait :all do
    type 'all'
  end
  
end