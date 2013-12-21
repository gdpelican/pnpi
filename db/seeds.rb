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
small = Tag.create! tag: '25-50', tag_type: seating
med = Tag.create! tag: '51-100', tag_type: seating
large = Tag.create! tag: '100+', tag_type: seating
sound = Tag.create! tag: 'Has sound system', tag_type: tech
lighting = Tag.create! tag: 'Has lighting grid', tag_type: tech
support = Tag.create! tag: 'Provides tech support', tag_type: tech
puts 'Tags created'

maura = Person.create!({ name: 'Maura Krause', preview: 'A short artistic statement about me', description: 'Hi, I\'m Maura', categories: [director, producer], tags: [kids, interact, mech], details: { email: 'mkrause@interact.org'  } })
maura_account = User.create!({ person: maura, password: 'interact', encrypted_password: Devise.bcrypt(Devise, 'interact' ), admin: true })

james = Person.create!({ name: 'James Kiesel', description: 'Hi, I\'m James', tags: [combatant, gdp], details: { email: 'james.kiesel@gmail.com' } })
james_acts = Skill.create!({ resource: james, category: actor })
james_directs = Skill.create!({ resource: james, category: director })
james_choreos = Skill.create!({ resource: james, category: choreo })
james_account = User.create!({ person: james, password: 'password', encrypted_password: Devise.bcrypt(Devise, 'password'), admin: false })
sample = Sample.create!({ skill: james_acts, description: 'An acting resume!' })

cubby = Person.create!({ name: 'Cubby Altobelli', description: 'It\'s Cubby!', tags: [clown], details: { email: 'cubby@cubby.com' } })
cubby_acts = Skill.create!({ resource: cubby, category: actor })
cubby_writes = Skill.create!({ resource: cubby, category: playwright })
cubbys_play = Sample.create!({ skill: cubby_writes, description: 'It\'s Cubby\s play!' })
puts 'People-Skills created'

places = Place.create!([
  { name: 'Plays and Players', description: 'We have Quigs!', categories: [performance, reading], tags: [small, support], details: { address: '1714 Delancey St' } },
  { name: 'Adrienne Theater', description: 'Interact lives here', categories: [performance, reading], tags: [interact, med, sound], owners: [maura] },
  { name: 'Community Education Center', description: '3500 Lancaster', categories: [reading, meeting] }
])
puts 'Venues created'

things = Thing.create!([
  { name: 'Ubu Mask', description: 'A mask for Ubu', categories: [borrow], owners: [james] },
  { name: 'That victrola we bought once', description: 'It was overpriced. It was worth it.', categories: [rent], details: { price: "25" } },
  { name: 'A Projector', description: 'A projector', categories: [borrow], owners: [james, cubby] }
])
puts 'Props created'
