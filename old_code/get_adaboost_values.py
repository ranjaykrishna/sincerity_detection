import operator
import sys
input = open('ada_vars.csv', 'r')
output = open(sys.argv[1], 'w')

feature_map = {}
for col in input.readlines():
  vals = col.replace('\"', '').split(',')
  feature = vals[1]
  weight = float(vals[2])
  if feature not in feature_map:
    feature_map[feature] = 0
  feature_map[feature] = feature_map[feature] + weight

sort = sorted(feature_map.iteritems(), key=operator.itemgetter(1))
for col in list(sort)[::-1]:
  output.write(col[0] + ',' + str(col[1]/10) + '\n')

input.close()
output.close()
