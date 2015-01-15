import jsonrpclib
import pymongo
from pymongo import MongoClient
from simplejson import loads

def get_collection():
  client = MongoClient()
  db = client.courteous
  collection = db.conversations
  return collection

def get_dependencies(record):
  server = jsonrpclib.Server("http://localhost:8080")
  male_sentences = []
  female_sentences = []
  male_parses = []
  female_parses = []
  for turn in record['male_turns']:
    result = loads(server.parse(turn))
    map(lambda sentence: male_sentences.append(sentence['text']), result['sentences'])
    map(lambda sentence: male_parses.append(sentence['dependencies']), result['sentences'])
  for turn in record['female_turns']:
    if len(turn) > 400:
      turn = turn[:400]
    result = loads(server.parse(turn))
    map(lambda sentence: female_sentences.append(sentence['text']), result['sentences'])
    map(lambda sentence: female_parses.append(sentence['dependencies']), result['sentences'])
  return {'male': {'sentences': male_sentences, 'parses': male_parses}, 'female': {'sentences': female_sentences, 'parses': female_parses}}

def create_dependencies():
  collection = get_collection()
  count = 0
  while collection.find({'dependencies': {'$exists': False}}).count() > 0:
    cursor = collection.find({'dependencies': {'$exists': False}})[:99]
    for record in cursor:
      print count
      count += 1
      dependencies = get_dependencies(record)
      collection.update({'_id': record['_id']}, {'$set': {'dependencies': dependencies}}, upsert=False)

if __name__ == "__main__":
  create_dependencies()
