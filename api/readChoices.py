import csv

metaCache = {}

# Returns dictionary of choices for fieldName from metadata file named meta.
def getChoices(meta,fieldName):
    if meta is None:
        raise Exception("Metadata not available. Data-dictionary must be present in the report directory.")
    cached = meta+':'+fieldName
    if cached in metaCache:
        return metaCache[cached]

    # Headers, as seen in manually exported dictionary.
    # API exported dictionary has different headers, selected below if necessary.
    varIdx = "Variable / Field Name"
    choicesIdx = "Choices, Calculations, OR Slider Labels"
    choices = ""
    try:
        with open(meta) as data:
            reader = csv.DictReader(data)
            for row in reader:
                if varIdx not in row:
                    varIdx = "field_name"
                if row[varIdx] == fieldName:
                    if choicesIdx not in row:
                        choicesIdx = "select_choices_or_calculations"
                    choices = row[choicesIdx]
                    break
    except IOError:
        raise Exception("Unable to read file %s. Data-dictionary must be present in the report directory."%(meta))

    choicesLst = choices.strip().split('|')
    choicesDct = {}
    for s in choicesLst:
        c = s.find(",")
        idx = s[:c].strip()
        name = s[c+1:].strip()
        choicesDct[idx] = name
    metaCache[cached] = choicesDct
    return choicesDct
