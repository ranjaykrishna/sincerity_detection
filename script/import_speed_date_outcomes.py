import csv
import utils

def import_rating(document):
  rating = {'male': {}, 'female': {}}
  if 'rating' in document:
    return document['rating']
  return rating

def create_ratings(document, rating, self_id, other_id):
  new_rating = import_rating(document)
  if self_id == document['male_id'] and other_id == document['female_id']:
    if 'o_crteos' in rating:
      new_rating['female']['courteous'] = rating['o_crteos']
    if 'o_funny' in rating:
      new_rating['female']['funny'] = rating['o_funny']
    if 'o_sincre' in rating:
      new_rating['female']['sincerity'] = rating['o_sincre']
  elif self_id == document['female_id'] and other_id == document['male_id']:
    if 'o_crteos' in rating:
      new_rating['male']['courteous'] = rating['o_crteos']
    if 'o_funny' in rating:
      new_rating['male']['funny'] = rating['o_funny']
    if 'o_sincre' in rating:
      new_rating['male']['sincerity'] = rating['o_sincre']
  return {'rating': new_rating}

csvfile = open('data/speeddateoutcomes.csv', 'rb')
spamreader = csv.reader(csvfile, delimiter=',')
line_number = 0
headers = []
ratings = []
for row in spamreader:
  if line_number == 0:
    headers = row
    line_number = 1
  else:
    rating = {}
    for index in range(len(row)):
      try:
        rating[headers[index]] = int(row[index])
      except:
        pass
    ratings.append(rating)

print headers
collection = utils.get_collection()
for rating in ratings:
  self_id= int(rating['selfid'])
  other_id = int(rating['otherid'])
  cursor = collection.find({'$or': [{'male_id': self_id, 'female_id': other_id}, 
                                    {'male_id': other_id, 'female_id': self_id}]})
  assert cursor.count() <= 1
  if cursor.count() < 1:
    continue
  document = cursor[0]
  obj = create_ratings(document, rating, self_id, other_id)
  print obj
  collection.update({'_id': document['_id']}, {'$set': obj}, upsert=False)
