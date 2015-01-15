import tweepy
import sys
import os
import re
import pymongo
from pymongo import MongoClient
from bson.objectid import ObjectId

def get_collection():
  client = MongoClient()
  db = client.courteous
  collection = db.conversations
  return collection

def save_conversation(male_id, female_id, male_turns, female_turns):
  collection = get_collection()
  obj = {'male_id': male_id,
         'female_id': female_id,
         'male_turns': male_turns,
         'female_turns': female_turns
        }
  #collection.update({'_id': obj['_id']}, {"$set": obj}, upsert=True)
  collection.insert(obj)

def document_already_parsed(male_id, female_id):
  collection = get_collection()
  return collection.find({'male_id': male_id, 'female_id': female_id}).count() > 0

def deal_with_file(folder, filename):
  m = re.match(r'([0-9][0-9][0-9])-([0-9][0-9][0-9])\.txt', filename)
  male_id = int(m.group(1))
  female_id = int(m.group(2))
  if female_id < male_id:
    temp = female_id
    female_id = male_id
    male_id = temp
  if document_already_parsed(male_id, female_id):
    return
  f = open(folder+'/'+filename, 'r')
  male_turns = []
  female_turns = []
  for line in f:
    m = re.match(r'[0-9]?[0-9]:[0-9][0-9]:?[0-9]?[0-9]?\.?[0-9]?[ \t]+[0-9]?[0-9]:[0-9][0-9]:?[0-9]?[0-9]?\.?[0-9]?[ \t]+F?E?MALE:[ \t]+(.*)', line)
    if m is not None:
      turn = m.group(1)
      if 'FEMALE:' in line:
        female_turns.append(turn)
      else:
        male_turns.append(turn)
  save_conversation(male_id, female_id, male_turns, female_turns)

if __name__ == "__main__":
  folder = '/Users/ranjaykrishna/Documents/workspace/courteous/conversations'
  filenames = os.listdir(folder)
  for filename in filenames:
    deal_with_file(folder, filename)
