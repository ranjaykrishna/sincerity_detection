import utils
from sklearn import svm
import numpy as np
from sklearn import cross_validation


politeness_feature_names = [
  'feature_politeness_==HASPOSITIVE==',
  'feature_politeness_==Apologizing==',
  'feature_politeness_==HASNEGATIVE==',
  'feature_politeness_==1st_person_pl.==',
  'feature_politeness_==1st_person==',
  'feature_politeness_==Please==',
  'feature_politeness_==Direct_question==',
  'feature_politeness_==INDICATIVE==',
  'feature_politeness_==1st_person_start==',
  'feature_politeness_==SUBJUNCTIVE==',
  'feature_politeness_==HASHEDGE==',
  'feature_politeness_==Indirect_(greeting)==',
  'feature_politeness_==Factuality==',
  'feature_politeness_==Deference==',
  'feature_politeness_==2nd_person==',
  'feature_politeness_==Gratitude==',
  'feature_politeness_==2nd_person_start==',
  'feature_politeness_==Indirect_(btw)==',
  'feature_politeness_==Hedges==',
  'feature_politeness_==Direct_start==',
  'feature_politeness_==Please_start=='
]


def build_features(gender):
  top_male_ids = utils.get_ids_for_quartile(gender, top=True)
  bottom_male_ids = utils.get_ids_for_quartile(gender, top=False)
  X = []
  y = []
  for id in top_male_ids:
    features = utils.get_politeness_features(id, politeness_feature_names, gender)
    X.append(features)
    y.append(1)
  for id in bottom_male_ids:
    features = utils.get_politeness_features(id, politeness_feature_names, gender)
    X.append(features)
    y.append(0)
  return np.array(X), np.array(y)

def train(X, y):
  X_train, X_test, y_train, y_test = cross_validation.train_test_split(
    X, y, test_size=0.1, random_state=0)
  clf = svm.SVC(kernel='linear', C=1).fit(X_train, y_train)
  print clf.score(X_test, y_test)

X, y = build_features('male')
train(X, y)
X, y = build_features('female')
train(X, y)
