# Gabriele Carotti-Sha
# CS 224S - Spring 2014 - Final Project
### Accomodation feature extraction ###

import os, re, csv, string, math, numpy
from sets import Set

# Accomodation features
# - RateAcc: correlation between turnwise rates of speech across speakers
# - ContWordAcc: number of content words also used in other's prior turn
# - LaughAcc: number of laughs immediately preceded by other laugh
# - FuncWordAcc: number of function words also used in other's prior turn
#		- auxiliary and copular verbs (1)
#		- conjunctions (2)
#		- determiners, predeterminers, quantifiers (3)
#		- pronouns and wh-words (4)
#		- prepositions (5)
#		- discourse particles (6)
#		- adverbs and negatives (7)

############## CLASSES and GLOBAL VARIABLES ##############

class Lexicon():
	def __init__(self):
		self.functionWords = 	[
									Set(['able','am','are','aren\'t','be','been','being','can','can\'t','cannot','could','could\'t','did','didn\'t','do','don\'t','get','got','gotta','had','hadn\'t','hasn\'t','have','haven\'t','is','isn\'t','may','should','should\'ve','shouldn\'t','was','were','will','won\'t','would','would\'ve','wouldn\'t']), 
									Set(['although', 'and','as','because','\'cause','but','if','or','so','then','unless','whereas','while']),
									Set(['a','an','each','every','all','lot','lots','the','this','those']),
									Set(['anybody','anything','anywhere','everybody\'s','everyone','everything','everything\'s','everywhere','he','he\'d','he\'s','her','him','himself','herself','his','I','I\'d','I\'ll','I\'m','I\'ve','it','it\'d','it\'ll','it\'s','its','itself','me','my','mine','myself','nobody','nothing','nowhere','one','one\'s','ones','our','ours','she','she\'ll','she\'s','she\'d','somebody','someone','someplace','that','that\'d','that\'ll','that\'s','them','themseves','these','they','they\'d','they\'ll','they\'re','they\'ve','us','we','we\'d','we\'ll','we\'re','we\'ve','what','what\'d','what\'s','whatever','when','where','where\'d','where\'s','wherever','which','who','who\'s','whom','whose','why','you','you\'d','you\'ll','you\'re','you\'ve','your','yours','yourself']),
									Set(['about','after','against','at','before','by','down','for','from','in','into','near','of','off','on','out','over','than','to','until','up','with','without']),
									Set(['ah','hi','huh','like','mm-hmm','oh','okay','right','uh','uh-huh','um','well','yeah','yup']),
									Set(['just','no','not','really','too','very'])
								]
										

class Dialogue():
	def __init__(self):
		self.maleID = ''
		self.femaleID = ''
		self.isMale = True
		self.features = [0, 0, 0, 0]	# 4 element vector


############## FUNCTIONS ##############

def swap(a, b):
	temp = a
	a = b
	b = temp
	return a, b


def getTime(t):
	regex = '\d?:?(\d?\d):(\d\d\.?\d?)'
	m = re.match(regex, t)
	return float(m.group(1)) * 60 + float(m.group(2))


def rateOfSpeech(line):

	start_t = getTime(line[0])
	end_t = getTime(line[1])

	number_of_words = len(line[3:])
	time_length = end_t - start_t
	if time_length == 0:
		ros = 0.
	else:
		ros = number_of_words*1. / time_length

	return ros


def updateFeatures(curr_line, prev_line, lex, dial):

	for word in curr_line[3]:
		if word in prev_line[3]:
			# count repeated words
			dial.features[1] += 1
			# count laughs
			if word == 'laughter':
				dial.features[2] += 1
			# find function words
			for category in lex.functionWords:
				if word in category:
					dial.features[3] += 1

	return dial


def computeCorrelation(x, y):

	diff = len(x) - len(y)
	n = len(x)
	if diff > 0:
		n = len(y)
		x = x[0:-diff]
	elif diff < 0:
		y = y[0:diff]
	
	X = numpy.array(x)
	Y = numpy.array(y)
	sumX = numpy.sum(X)
	sumY = numpy.sum(Y)
	num = n*numpy.sum(X*Y) - sumX*sumY
	denom = numpy.sqrt( ( n*numpy.sum(X**2) - sumX**2 ) * ( n*numpy.sum(Y**2) - sumY**2 ) )

	if denom == 0:
		return 0.
	return num / denom


def parseLine(l):

	regex = r'(\d?\d:\d\d:?\d?\d?.?\d?)\s*(\d?\d:\d\d:?\d?\d?.?\d?)\s*(\w+\s?\d?):\s*(.*)'
	m = re.match(regex, l)
	if not m: return []
	start_t, end_t, gender, text = m.group(1), m.group(2), m.group(3), m.group(4)
	text = text.translate(string.maketrans('!"#$%&()*+,-./:;<=>?@[\\]^_`{|}~',' '*(len(string.punctuation)-1)))
	gender = gender.lower()

	return [start_t, end_t, gender, text]


def getIDs(line):

	regex = '.*(\d\d\d).*(\d\d\d).*'
	m = re.match(regex, line)
	return m.group(1), m.group(2)


def readDialogue(f, filename, dialogues, lex):

	print filename

	dialMale = Dialogue()
	dialFem = Dialogue()
	rosMale = [] # rates of speech
	rosFem = []

	line = f.readline()

	maleID, femaleID = getIDs(line)

	if int(maleID) > int(femaleID):
		maleID, femaleID = swap(maleID, femaleID)
	dialMale.maleID, dialMale.femaleID = maleID, femaleID
	dialFem.maleID, dialFem.femaleID = maleID, femaleID
	dialFem.isMale = False

	prev_line = "\n"
	while (prev_line == "\n") or (parseLine(prev_line) == []):
		prev_line = f.readline()

	prev_line = parseLine(prev_line)

	if prev_line[2] == 'male':
		rosMale.append(rateOfSpeech(prev_line))
	else:
		rosFem.append(rateOfSpeech(prev_line))

	line = f.readline()
	# parse each line to find text
	while line:
		if line != "\n" and line != "": 
			curr_line = parseLine(line)
			if curr_line != []: 
				if curr_line[2].split()[0] == 'male':
					if curr_line[2][-1].isdigit():
						curr_line[0] = prev_line[0]
						curr_line[2] = prev_line[2]
						curr_line[3] = prev_line[3] + " " + curr_line[3]
						rosMale = rosMale[:-1]
					dialMale = updateFeatures(curr_line, prev_line, lex, dialMale)
					rosMale.append(rateOfSpeech(curr_line))
				else:
					if curr_line[2][-1].isdigit():
						curr_line[0] = prev_line[0]
						curr_line[2] = prev_line[2]
						curr_line[3] = prev_line[3] + " " + curr_line[3]
						rosFem = rosFem[:-1]
					dialFem = updateFeatures(curr_line, prev_line, lex, dialFem)
					rosFem.append(rateOfSpeech(curr_line))

				prev_line = curr_line

		line = f.readline()

	dialMale.features[0] = dialFem.features[0] = computeCorrelation(rosMale, rosFem)
	dialogues.append(dialMale)
	dialogues.append(dialFem)


def generateCSV(data, name):
	with open(name, 'a') as csvfile:
		output = csv.writer(csvfile, delimiter=',')
		output.writerows(data)


############## MAIN ##############

if __name__ == "__main__":

	count = 1

	dialogues = []
	lex = Lexicon()

	print "Reading text files..."

	# Read in dialogues
	path = "../dataset/speeddate/"
	for filename in os.listdir(path):

		if re.match('^[^._].*.txt', filename):
			count += 1
			f = open(path + filename,"r")
			readDialogue(f, filename, dialogues, lex)

		#if count > 1: break

	print "Saving data as .csv file..."

	# Save CSV file
	data = []
	for dial in dialogues:
		row = []
		for feat in dial.features:
			row.append(feat)
		row.append(dial.maleID)
		row.append(dial.femaleID)
		row.append(dial.isMale)
	
		data.append(row)

	generateCSV(data, 'acc_features.csv')

	print "\nDONE"






