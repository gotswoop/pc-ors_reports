import csv
import os

PEOPLE = os.path.join(os.path.dirname(__file__), 'people.csv')
#Changing this to a relative classpath. 
#PEOPLE = "/data/plugins/orsbilling/reports/orsbilling/people.csv"
pplCache = {}

# Returns list of usernames for personName from people list.
def getUsernames(personName):
    cached = 'people'+':'+personName
    if cached in pplCache:
        return pplCache[cached]

    choices = ""
    try:
        with open(PEOPLE) as data:
            reader = csv.reader(data)
            for row in reader:
                if len(row)==0: continue
                if row[0].strip() == personName.strip():
                    choices = "|".join(row[1:])
                    break
    except IOError:
        raise Exception("Unable to read people file %s. CSV of person to username mappings must be present in the report directory."%(PEOPLE))

    choicesLst = choices.strip().split('|')
    pplCache[cached] = choicesLst
    return choicesLst

