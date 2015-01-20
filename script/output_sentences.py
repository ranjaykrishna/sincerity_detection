import utils
import json

f = open('data/aggregated_sentences.json', 'w')
collection = utils.get_collection()
cursor = collection.find({}, {'male_id': 1, 'female_id': 1, '_id': 0, 'male_turns': 1, 'female_turns': 1})
f.write(json.dumps(list(cursor)))
f.close()

