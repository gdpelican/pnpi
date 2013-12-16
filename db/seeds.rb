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

clown = Tag.create({ tag: 'Clown', resource: 'person', category: 'actor' })
combatant = Tag.create(  { tag: 'Combatant', resource: 'person', category: 'actor' })
kids = Tag.create({ tag: 'Works with kids', resource: 'person', category: 'director' })
puts 'Person tags created'

rent = Price.create!({ name: 'Rent' })
borrow = Price.create({ name: 'Borrow' })
puts 'Prices created'

people = Person.create!({ name: 'Maura Krause', description: 'Hi, I\'m Maura', categories: [director, producer], tags: [kids] })

james = Person.create!({ name: 'James Kiesel', description: 'Hi, I\'m James', tags: [combatant], details: { email: 'james.kiesel@gmail.com' } })
james_acts = Skill.create!({ resource: james, category: actor })
james_directs = Skill.create!({ resource: james, category: director })
james_choreos = Skill.create!({ resource: james, category: choreo })
sample = Sample.create!({ skill: james_acts, description: 'An acting resume!' })

cubby = Person.create!({ name: 'Cubby Altobelli', description: 'It\'s Cubby!', tags: [clown], details: { email: 'cubby@cubby.com' } })
cubby_acts = Skill.create!({ resource: cubby, category: actor })
cubby_writes = Skill.create!({ resource: cubby, category: playwright })
cubbys_play = Sample.create!({ skill: cubby_writes, description: 'It\'s Cubby\s play!' })
puts 'People-Skills created'

places = Place.create!([
  { name: 'Plays and Players', description: 'We have Quigs!', categories: [performance, reading], details: { address: '1714 Delancey St' } },
  { name: 'Adrienne Theater', description: 'Interact lives here', categories: [performance, reading] },
  { name: 'Community Education Center', description: '3500 Lancaster', categories: [reading, meeting] }
])
puts 'Venues created'

things = Thing.create!([
  { name: 'Ubu Mask', description: 'A mask for Ubu', categories: [borrow] },
  { name: 'That victrola we bought once', description: 'It was overpriced. It was worth it.', categories: [rent], details: { price: "25" } },
  { name: 'A Projector', description: 'A projector', categories: [borrow] }
])
puts 'Props created'

Tag.create!([
  { tag: 'Provides tech support', resource: 'place', category: 'performance' },
  { tag: 'Has lighting grid', resource: 'place' },
  { tag: 'Has rental contract', resource: 'place', category: 'staged-reading' },
  { tag: 'Handicap accessible', resource: 'place' },
  { tag: 'Set piece', resource: 'thing' },
  { tag: 'Tech equipment', resource: 'thing' },
  { tag: 'Antique', resource: 'thing', category: 'borrow' }
])
puts 'Tags created'
