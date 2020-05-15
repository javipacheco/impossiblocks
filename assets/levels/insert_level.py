import os
import sys

numberToInsert = int(sys.argv[1])
maxLevel = int(sys.argv[2])

for n in range(maxLevel, numberToInsert, -1):
    os.rename('level_'+ str(n) + '.json', 'level_'+ str(n+1) + '.json')
    print(str(n) + ' now is ' + str(n+1))
