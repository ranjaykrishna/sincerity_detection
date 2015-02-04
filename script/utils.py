import pymongo
from pymongo import MongoClient

def get_collection():
  client = MongoClient()
  db = client.courteous
  collection = db.conversations
  return collection

def get_politeness_features(query, feature_names, gender):
  collection = get_collection()
  doc = collection.find(query)[:1]
  if doc.count() == 0:
   return None
  doc = doc[0]
  doc_features = {d['name']: d['value'] for d in doc['politeness_features'][gender]} 
  features = []
  for feature_name in feature_names:
    features.append(doc_features[feature_name])
  return features

def get_courteous_rating(query, gender):
  collection = get_collection()
  doc = collection.find(query)[:1]
  if doc.count() == 0:
   return None
  doc = doc[0]
  if 'rating' in doc and gender in doc['rating'] and 'normalized_courteous' in doc['rating'][gender]:
    return doc['rating'][gender]['normalized_courteous']
  return None

def get_ids_for_quartile(gender, top=True):
  order = pymongo.ASCENDING
  if top:
   order = pymongo.DESCENDING
  collection = get_collection()
  elem = 'rating.' + gender + '.normalized_courteous'
  total = collection.find({elem: {'$exists': True}}).count()
  return collection.find({elem: {'$exists': True}}, {'_id': 1}).sort([(elem, order)])[:total/10]

def find_doc(id1, id2):
  collection = get_collection()
  docs = collection.find({'male_id':id1, 'female_id':id2})
  if docs.count() > 0:
    return docs[0]
  docs = collection.find({'female_id':id1, 'male_id':id2})
  if docs.count() > 0:
    return docs[0]
  return None 
