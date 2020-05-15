import json
import codecs

locales = ["es", "en", "pt", "de", "it", "hi", "fr", "ru", "ja", "zh"]

input_file  = file("translations.json", "r")
data = json.loads(input_file.read().decode("utf-8-sig"))

for locale in locales:
    loc = data['Hoja 1'][locale]
    output_file = codecs.open('i18n_' + locale + '.json', "w", encoding="utf-8")
    json.dump(loc, output_file, indent=4, sort_keys=True, ensure_ascii=False)
    print(locale + " created")
