import utils
import numpy as np
from matplotlib import pyplot as plt

collection = utils.get_collection()
cursor = collection.find({'politeness.female': {'$exists': True}, 'rating.female.courteous': {'$exists': True}})
politeness = []
courteous = []
for obj in cursor:
  politeness.append(obj['politeness']['female'])
  courteous.append(obj['rating']['female']['courteous'])
print courteous
plt.scatter(np.array(politeness), np.array(courteous))
plt.show()
