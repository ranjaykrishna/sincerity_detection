input = open('norm_liwc_feats.csv', 'r')
output = open('fixed_liwc_feats.csv', 'w')

incorrect_rows = [[621,1260], [1907,2556], [3089,3654]]

row = 1
for line in input.readlines():
  incorrect = False
  for group in incorrect_rows:
    if row >= group[0] and row <= group[1]:
      incorrect = True
      print row
      break
  if incorrect:
    if 'TRUE' in line:
      line = line.replace('TRUE', 'FALSE')
    elif 'FALSE' in line:
      line = line.replace('FALSE', 'TRUE')
  output.write(line)
  row = row + 1

input.close()
output.close()
