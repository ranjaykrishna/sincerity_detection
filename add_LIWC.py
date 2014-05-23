liwc_file = open('LIWC_features.csv', 'r')
feature_file = open('ForAnalysis.csv', 'r')
output_file = open('all_features.csv', 'w')

feature_map = {}
n = None
for line in liwc_file:
  features = line.split(',')
  if n == None:
    n = len(features) - 3
  gender = features[len(features)-1]
  male = features[len(features)-2]
  female = features[len(features)-3]
  speaker = male if 'True' in gender else female
  feature_map[speaker] = features[0:len(features)-3]
  
for line in feature_file:
  if 'selfid' in line:
    output_file.write(line)
    continue
  features = line.split(';')
  if features[0] in feature_map:
    output = features + feature_map[features[0]][0:n]
  else:
    output = features + ([0] * n)
    print str(features[0]) + ' is not in liwc'
  output_file.write(';'.join(output).replace('\n', '') + '\n')

feature_file.close()
liwc_file.close()
output_file.close()

