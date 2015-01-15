# Gabriele Carotti-Sha
# CS 224S - Spring 2014 - Final Project
### Lexical feature extraction ###

import os, re, csv, string, math
from sets import Set

"""
Lexical Features: 
	- Hedge words (sort of, kind of, I guess, I think, a little, maybe, possibly, probably)
	- Meta (speed date, flirt, event, dating, rating)
	- Academics (work*, program, PhD, research, professor*, advisor, finish*)
	- Like (the discourse marker like (removing cases of the verb like))
	- I mean (the discourse marker I mean)
	- You know (discourse marker _you know_)
	- uh (filled pause)
	- um (filled pause)

	- Syllables-per-word
	- Avg. number of syllables-per-turn
	- Inverse frequency of words used

LIWC features
	- I (I'd, I'll, I'm, I've, me, mine, my, myself)
	- YOU (you, you'd, you'll, your, you're, yours, you've)
	- SEX (sex, sexy, sexual, stripper, lover, kissed, kissing)
	- LOVE (love, love, loving, passion, passions, passionate)
	- HATE (hate, hates, hated)
	- SWEAR (suck*, hell*, crap*, shit*, screw*, damn*, heck, ass*...)
	- NEGEMO (bad, weird, crazy, problem*, tough, awkwrd, worry...)
	- NEGATE (don't, not, no, didn't, never, haven't, can't, wouldn't, nothing...)
	- FOOD (food, eat*, cook*, dinner, restaurant, coffee, chocolate, cookies, ...)
	- DRINK (party, bar*, drink*, wine*, beer*, drunk, alcohol*, cocktail...)
	...
"""

#############################################

class Lexicon():

	def __init__(self):
		# dictionary data structure to contain features
		# first parameter of each value is the count or computed value; second parameter is position
		self.d = {
					'sort of':[0,1],	# hedge words
					'kind of':[0,2],
					'i guess':[0,3],
					'i think':[0,4],
					'a little':[0,5],
					'maybe':[0,6],
					'possibly':[0,7],
					'probably':[0,8],
					'speed date':[0,9],	# meta
					'flirt':[0,10],
					'event':[0,11],
					'dating':[0,12],
					'rating':[0,13],
					'work':[0,14],		# academics
					'program':[0,15],
					'phd':[0,16],
					'research':[0,17],
					'professor':[0,18],
					'advisor':[0,19],
					'finish':[0,20],
					'like':[0,21],		# discourse marker
					'i mean':[0,22],
					'you know':[0,23],
					'uh':[0,24],
					'um':[0,25],
					'syllables_per_word':[0,26],
					'syllables_per_turn':[0,27],
				}

word_doc_freq = [{},{}]
tf_idf = []
total_word_set = Set([])
num_features = 30

#############################################

def findSyllables(word):
	# count vowel groups
	vowels = 'aeiouy'
	count = 0
	flag = 1
	for c in word:
		if (c in vowels) and flag:
			count += 1
			flag = 0
		else: flag = 1
	return count
	

def searchWord(text, lex, syllable_count, word_dict, index, word_set):

	for i, word in enumerate(text):
		word = text[i].lower()
		word_set.add(word)
		total_word_set.add(word)

		# word frequency within document
		if word in word_dict:
			word_dict[word] = word_dict[word]+1
		else:
			word_dict[word] = 1

		# find number of syllables in each word
		num_syllables = findSyllables(word)
		if num_syllables > 0:
			syllable_count.append(num_syllables)

		# count frequency of words from the Lexicon
		if word in lex.d:
			lex.d[word][0] = lex.d[word][0] + 1
		if i < len(text)-1:
			bigram = (word + ' ' + text[i+1].lower())
			if bigram in lex.d:
				lex.d[bigram][0] = lex.d[bigram][0] + 1

	return syllable_count, word_dict, word_set


def populate_data(data, lex, syllable_count, turn_count):
	# transfer values from lexicon dictionary to data for csv
	lex.d['syllables_per_word'][0] = sum(syllable_count)*1./len(syllable_count)
	lex.d['syllables_per_turn'][0] = sum(syllable_count)*1./turn_count		
	for key, val in lex.d.iteritems():
		if len(data[val[1]]) == 0:
			data[val[1]].append(key)
		data[val[1]].append(val[0])


def computeTermFrequency(doc_length, word_dict):
	for key, val in word_dict.iteritems():
		if key in word_dict:
			# compute tf factor
			word_dict[key] = (word_dict[key]*1./doc_length)
	tf_idf.append(word_dict)


def computeWordDocFrequency(index, word_set):
	for word in word_set:
		if word in word_doc_freq[index]:
			word_doc_freq[index][word] = word_doc_freq[index][word] + 1
		else:
			word_doc_freq[index][word] = 1


def computeTFIDF(doc_num):
	for i, doc in enumerate(tf_idf):
		for word in doc:
			# multiply by idf factor
			tf_idf[i][word] *= math.log( doc_num*1. / word_doc_freq[i%2][word] ) 


def generateCSV(data, name):
	with open(name, 'a') as csvfile:
		output = csv.writer(csvfile, delimiter=',')
		output.writerows(data)


def saveTFIDF(flag):
	n_words = len(total_word_set)
	n_docs = len(tf_idf)
	data = [range(0,n_docs/2+1)]

	for word in total_word_set:
		row = [word] + [0]*(n_docs/2)
		for j, doc in enumerate(tf_idf):
			if j%2 == flag and word in doc:
				row[(j-flag)/2+1] = tf_idf[j][word] 
		data.append(row)

	if flag: 
		name = 'female_tfidf.csv'
	else: name = 'male_tfidf.csv' 
	generateCSV(data, name)


def transpose(m):
	height = len(m)
	width = len(m[0])
	return [[ m[row][col] for row in range(0,height) ] for col in range(0,width) ]


def convertData(data, isMale):
	newData = []
	for i in range(0,len(data)):
		newRows = [['']*num_features, ['']*num_features]
		for row in data:
			if type(row[0]) == int:
				index = 0
				newRows[0][27] = row[1]
				newRows[0][28] = row[2]
				newRows[0][29] = isMale
				newRows[1][27] = row[1]
				newRows[1][28] = row[2]
				newRows[1][29] = not isMale
			else: 
				newRows[0][index] = row[1]
				newRows[1][index] = row[2]
				index += 1

		if i%28 == 0:
			newData.append(newRows[0])
			newData.append(newRows[1])

	return newData

def swap(a, b):
	temp = a
	a = b
	b = temp
	return a, b


#############################################

if __name__ == "__main__":

	path = "../dataset/speeddate/"
	count = 1

	# run through each document in folder
	for filename in os.listdir(path):
		if re.match('.*\.TextGrid', filename):

			maleID, femaleID = re.findall('(\d\d\d)-(\d\d\d)', filename)[0]
			isMale = True
			if int(maleID) > int(femaleID):
				maleID, femaleID = swap(maleID, femaleID)
				#isMale = False

			# initialization
			data = [[count,'male'+maleID,'female'+femaleID]]
			for x in range(0,27):
				data.append([])
			lex = Lexicon()	# objects containing lexical feature counts
			turn_count = 0
			syllable_count = []	# number of syllables in each sentence
			word_dict = {}	# term frequencies for each document
			flag = 0
			word_set = Set([])

			f = open(path + filename,"r")
			line = f.readline()
			# parse each line to find text
			while line:
				l = line.translate(string.maketrans(string.punctuation,' '*len(string.punctuation)))
				l = l.split()
				if len(l) > 1 and l[1] == 'FEMALE': 
					# load all data for MALE
					populate_data(data, lex, syllable_count, turn_count)
					computeTermFrequency(len(syllable_count), word_dict)
					computeWordDocFrequency(flag, word_set)
					# re-initialize for FEMALE data
					lex = Lexicon()
					turn_count = 0
					syllable_count = []
					word_dict = {}
					flag = 1
					word_set = Set([])
				# extract text information
				if (len(l) != 0) and (l[0] == 'text'):
					syllable_count, word_dict, word_set = searchWord(l[1:], lex, syllable_count, word_dict, flag, word_set)
					turn_count += 1
				line = f.readline()
			# load all data for FEMALE
			populate_data(data, lex, syllable_count, turn_count)
			computeTermFrequency(len(syllable_count), word_dict)
			computeWordDocFrequency(flag, word_set)
			f.close()

			newData = convertData(data, isMale) # reformat data matrix for Sidd :)
			# load both MALE and FEMALE columns of data into csv file
			#generateCSV(newData, 'lex_feat_reformatted.csv')

			# move on to next document
			count += 1

	#computeTFIDF(count)
	#saveTFIDF(0)
	#saveTFIDF(1)



