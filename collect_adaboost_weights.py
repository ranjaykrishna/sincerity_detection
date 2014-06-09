funny_lex_male = open('funny_lex_male_adaboost_weights.csv', 'r')
funny_lex_female = open('funny_lex_female_adaboost_weights.csv', 'r')
funny_pros_male = open('funny_pros_male_adaboost_weights.csv', 'r')
funny_pros_female = open('funny_pros_female_adaboost_weights.csv', 'r')
crteos_lex_male = open('crteos_lex_male_adaboost_weights.csv', 'r')
crteos_lex_female = open('crteos_lex_female_adaboost_weights.csv', 'r')
crteos_pros_male = open('crteos_pros_male_adaboost_weights.csv', 'r')
crteos_pros_female = open('crteos_pros_female_adaboost_weights.csv', 'r')

def get_name(s):
  return s.split(',')[0].replace('.', ' ').replace('M','m').replace('_', ' ')

for i in range(10):
  print str(i+1) + ' & ' + get_name(funny_lex_male.readline()) + ' & ' + get_name(funny_lex_female.readline()) + ' & ' + get_name(funny_pros_male.readline()) + ' & ' + get_name(funny_pros_female.readline()) + ' & ' + get_name(crteos_lex_male.readline()) + ' & ' + get_name(crteos_lex_female.readline()) + ' & ' + get_name(crteos_pros_male.readline()) + ' & ' + get_name(crteos_pros_female.readline()) + '\\\\' 
