import utils
import csv

def create_feature_dict(names, values):
  output = {}
  for x in range(2, len(values)):
    output[names[x]] = float(values[x])
  return output

collection = utils.get_collection()
f = open('data/danfeatures.mar102011.csv', 'rb')
reader = csv.reader(f, delimiter=',')
is_header = True
headers = []
for row in reader:
  if is_header:
    headers = row
    is_header = False
    continue
  doc = utils.find_doc(int(row[0]), int(row[1]))
  if doc is not None:
    features = create_feature_dict(headers, row)
    gender = 'female'
    if int(row[0]) == doc['male_id']:
      gender = 'male'
    key = 'lexical_features.' + gender
    collection.update({'_id':doc['_id']}, {'$set': {key: features}}, False, True)

