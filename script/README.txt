To remove dependencies with no sentences:
db.conversations.find({'dependencies.male.sentences': {$size: 0}}, {dependencies: true}).count()

To check how many documents have empty dependency sentences and parses:
db.conversations.find({'dependencies.male.sentences': {$size: 0}}, {dependencies: true}).count()

To check how many more objects need to be parsed:
db.conversations.find({dependencies: {$exists: false}}, {dependencies: true}).count()
