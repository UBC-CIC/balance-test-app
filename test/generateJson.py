import json
 
# Data to be written
dictionary = {
    "gz": [-1.5106201171875]*12000
}

output = {}
for i in range(12000):
    output[i] = dictionary
 
# Serializing json
json_object = json.dumps(dictionary, indent=4)
 
# Writing to sample.json
with open("sample.json", "w") as outfile:
    outfile.write(json_object)