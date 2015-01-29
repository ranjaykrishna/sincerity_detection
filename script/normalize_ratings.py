import pymongo
from pymongo import MongoClient
import utils

collection = utils.get_collection()
for agg in collection.aggregate([{'$group': {'_id': '$male_id', 'avg': {'$avg': '$rating.female.courteous'}}}])['result']:
  for doc in collection.find({'male_id': agg['_id'], 'rating.female.courteous': {'$exists': True}}):
    collection.update({'_id': doc['_id']}, {'$set': {'rating.female.normalized_courteous': doc['rating']['female']['courteous']/agg['avg']}}, upsert=False)
for agg in collection.aggregate([{'$group': {'_id': '$female_id', 'avg': {'$avg': '$rating.male.courteous'}}}])['result']:
  for doc in collection.find({'female_id': agg['_id'], 'rating.male.courteous': {'$exists': True}}):
    collection.update({'_id': doc['_id']}, {'$set': {'rating.male.normalized_courteous': doc['rating']['male']['courteous']/agg['avg']}}, upsert=False)
