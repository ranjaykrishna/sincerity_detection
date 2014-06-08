# Gabriele Carotti-Sha
# CS 224S - Spring 2014 - Final Project
### LIWC feature extraction ###

import os, re, csv, string, math
from sets import Set

############## CLASSES and GLOBAL VARIABLES ##############

class Lexicon():
	def __init__(self):
		self.classes = {}
		self.terms = {}
		

class Dialogue():
	def __init__(self):
		self.maleID = ''
		self.femaleID = ''
		self.text = ''
		self.isMale = True
		self.features = {}
		self.wordCount = 0

############## FUNCTIONS ##############

def swap(a, b):
	temp = a
	a = b
	b = temp
	return a, b


def importDictionary(f):
	lex = Lexicon()
	for line in f:
		l = line.split()
		if l[0] == '%':
			break
		lex.classes[l[0]] = l[1]

	for line in f:
		l = line.split()
		lex.terms[l[0]] = [int(i) for i in l[1:]]

	return lex


def countLexicalFeatures(dial, lex):

	for term in lex.terms:
		regex = '(' + term + ')'
		if term[-1] == '*':
			regex = '(' + term[:-1] + '\w+)'
		
		output = re.findall(regex,dial.text)
		
		if output != [] and term[-1]=='*':
			count = len(output)
			for i in lex.terms[term]:
				c = lex.classes[str(i)]
				dial.features[c] += 1
	
	# NORMALIZE ALL TERM COUNTS
	


def readDialogue(f, filename, dialogues):

	dial = Dialogue()

	maleID, femaleID = re.findall('(\d\d\d)-(\d\d\d)', filename)[0]
	if int(maleID) > int(femaleID):
		maleID, femaleID = swap(maleID, femaleID)
		dial.isMale = False
	dial.maleID, dial.femaleID = maleID, femaleID

	line = f.readline()
	# parse each line to find text
	while line:
		l = line.translate(string.maketrans('!"#$%&()*+,-./:;<=>?@[\\]^_`{|}~',' '*(len(string.punctuation)-1)))
		l = l.split()

		if len(l) > 1 and l[1] == 'FEMALE': 
			dialogues.append(dial)
			newDial = Dialogue()
			newDial.text = ''
			newDial.maleID, newDial.femaleID = dial.maleID, dial.femaleID
			newDial.isMale = not dial.isMale
			dial = newDial

		# extract text information
		if (len(l) != 0) and (l[0] == 'text'):
			dial.text += ' ' + ' '.join(l[1:]).lower()

		line = f.readline()

	dialogues.append(dial)


def generateCSV(data, name):
	with open(name, 'a') as csvfile:
		output = csv.writer(csvfile, delimiter=',')
		output.writerows(data)
		

############## MAIN ##############

if __name__ == "__main__":

	count = 1

	# Read in LIWC from .dic file
	path = "../dataset/"
	filename = "LIWC2007_English080730.dic"
	f = open(path + filename,"r")

	lex = importDictionary(f)
	dialogues = []

	# Read in dialogues
	path = "../dataset/speeddate/"
	for filename in os.listdir(path):
		if re.match('.*\.TextGrid', filename):
			print "Extracting from ", filename
			count += 1
			f = open(path + filename,"r")
			readDialogue(f, filename, dialogues)

		#if count > 1: break

	# Count features
	for dial in dialogues:
		dial.wordCount += len(dial.text.split())
		#for key, value in lex.classes.items():
		#	dial.features[value] = 0
		#countLexicalFeatures(dial, lex)


	data = []
	r = []
	print "Constructing rows..."
	for i, dial in enumerate(dialogues):
		row = []
		for feat in dial.features:
			row.append(dial.features[feat])
		row.append(dial.maleID)
		row.append(dial.femaleID)
		row.append(dial.isMale)	
		data.append(row)

		r.append([dial.wordCount])

	print "Saving to .csv..."
	generateCSV(data, 'LIWC_features.csv')
	#generateCSV(r,'dial_counts.csv')





