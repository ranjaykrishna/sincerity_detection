feature_file = open('all_features.csv', 'r')
results_file = open('../data/speeddateoutcomes.csv')
output_file = open('sparse_features.txt', 'w')

def get_feature_list(features):
  output = []
  for k,v in enumerate(features):
    try:
      x = float(v)
      if float(v) == 0:
        continue
      output.append(str(int(k+1)) + ':' + str(x))
    except:
      if v == 'TRUE':
        output.append(str(int(k+1)) + ':1.0')
      elif v == 'FALSE':
        output.append(str(int(k+1)) + ':0.0')
      else:
        print v
      continue
  return ' '.join(output) 

results_map = {}
for line in results_file:
  vals = line.split(',')
  results_map[vals[0]] = vals[16]

for line in feature_file:
  if 'selfid' in line:
    continue
  features = line.replace('\"', '').split(';')
  if features[0] in results_map:
    result = results_map[features[0]]
    if result == '.':
      continue
    output_file.write(str(result) + ' ' + get_feature_list(features[25:]) + '\n')
  else:
    print str(feature[0]) + "not in feature list"

output_file.close()
feature_file.close()
results_file.close()
