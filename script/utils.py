import pymongo
from pymongo import MongoClient

def get_collection():
  client = MongoClient()
  db = client.courteous
  collection = db.conversations
  return collection


