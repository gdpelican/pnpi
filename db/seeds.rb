actor = Job.create!({ name: 'Actor' })
director = Job.create!({ name: 'Director' })
choreo = Job.create!({ name: 'Choreographer' })
producer = Job.create!({ name: 'Producer' })
playwright = Job.create!({ name: 'Playwright' })
puts 'Jobs created'

performance = Event.create!({ name: 'Performance' })
meeting = Event.create!({ name: 'Meeting' })
reading = Event.create!({ name: 'Staged Reading' })
puts 'Events created'

rent = Price.create!({ name: 'Rent' })
borrow = Price.create({ name: 'Borrow' })
puts 'Prices created'

specskill = TagType.create!(name: 'Special Skills', resource: 'person', category: 'actor')
dirskill = TagType.create!(name: 'Director Skills', resource: 'person', category: 'director')
genskill = TagType.create!(name: 'Other Skills', resource: 'person')
company = TagType.create!(name: 'Company Affiliation', resource: 'person' )
seating = TagType.create!(name: 'Seats', resource: 'place')
tech = TagType.create!(name: 'Tech', resource: 'place')
puts 'Tag types created'

clown = Tag.create!(tag: 'Clown', tag_type: specskill)
combatant = Tag.create! tag: 'Combatant', tag_type: specskill
license = Tag.create! tag: 'Valid Driver\'s license', tag_type: genskill
kids = Tag.create! tag: 'Works with kids', tag_type: genskill
interact = Tag.create! tag: 'Interact', tag_type: company
gdp = Tag.create! tag: 'GDP Productions', tag_type: company
mech = Tag.create! tag: 'Applied Mechanics', tag_type: company
small = Tag.create! tag: '25-50 seats', tag_type: seating
med = Tag.create! tag: '51-100 seats', tag_type: seating
large = Tag.create! tag: '100+ seats', tag_type: seating
sound = Tag.create! tag: 'Has sound system', tag_type: tech
lighting = Tag.create! tag: 'Has lighting grid', tag_type: tech
support = Tag.create! tag: 'Provides tech support', tag_type: tech
puts 'Tags created'

maura = Person.create!({ name: 'Maura Krause', 
                         preview: 'A short artistic statement about me', 
                         description: 'Hi, I\'m Maura',
                         active: true, 
                         categories: [director, producer], 
                         picture: File.new("#{Rails.root}/db/seed_images/maura.jpg"),
                         tags: [kids, interact, mech], 
                         details: { email: 'mkrause@interact.org' } })
maura_account = User.create!({ person: maura, password: 'interact', encrypted_password: Devise.bcrypt(Devise, 'interact' ), admin: true })

james = Person.create!({ name: 'James Kiesel', 
                         description: 'Hi, I\'m James', 
                         active: true,
                         tags: [combatant, gdp], 
                         categories: [actor, director, producer, choreo],
                         picture: File.new("#{Rails.root}/db/seed_images/james.jpg"),
                         details: { email: 'james.kiesel@gmail.com' } })
james_account = User.create!({ person: james, password: 'password', encrypted_password: Devise.bcrypt(Devise, 'password'), admin: false })
sample = Sample.create!({ person: james, job: actor, name: 'An acting resume!' })

cubby = Person.create!({ name: 'Cubby Altobelli', 
                         description: 'It\'s Cubby!', 
                         active: true,
                         tags: [clown, license], 
                         categories: [actor, playwright],
                         picture: File.new("#{Rails.root}/db/seed_images/cubby.jpg"),
                         details: { email: 'cubby@cubby.com' } })
cubbys_play = Sample.create!({ person: cubby, job: playwright, name: 'It\'s Cubby\s play!' })

oliver = Person.create!({ name: 'Oliver Donahue', 
                          preview: 'Resident fight director for the 95 Runagates', 
                          description: 'Oliver Donahue has been working as a fight director for over 6 years in and around the Philadelphia region. He is a Certified Teacher with Fight Directors Canada, and has apprenticed under Fight Master Ian Rose. Past credits include Dust to Dust, After the End, and Sex & Violence.', 
                          categories: [actor, choreo], 
                          tags: [gdp, license, combatant],
                          picture: File.new("#{Rails.root}/db/seed_images/oliver.jpg"), 
                          details: { email: 'oliver@donahue.com'} })
puts 'People created'

places = Place.create!([
  { name: 'Plays and Players', description: 'We have Quigs!', active: true, categories: [performance, reading], tags: [small, support], details: { address: '1714 Delancey St' } },
  { name: 'Adrienne Theater', description: 'Interact lives here', active: true, categories: [performance, reading], tags: [interact, med, sound], owners: [maura] },
  { name: 'Community Education Center', description: '3500 Lancaster', categories: [reading, meeting] }
])
puts 'Venues created'

things = Thing.create!([
  { name: 'Ubu Mask', description: 'A mask for Ubu', active: true, owners: [james] },
  { name: 'That victrola we bought once', description: 'It was overpriced. It was worth it.', active: true, details: { price_per_period: '25.00 / week' } },
  { name: 'A Projector', description: 'A projector', active: true, owners: [james, cubby] }
])
puts 'Props created'
