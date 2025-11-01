extends Node

# Set mod priority if you want it to load before/after other mods
# Mods are loaded from lowest to highest priority, default is 0
const MOD_PRIORITY = 0
# Name of the mod, used for writing to the logs
const MOD_NAME = "1 in 10,000 Chance Withered Foxy Jumpscare Every Second"
const MOD_VERSION_MAJOR = 1
const MOD_VERSION_MINOR = 0
const MOD_VERSION_BUGFIX = 0
const MOD_VERSION_METADATA = ""
var modPath:String = get_script().resource_path.get_base_dir() + "/"

var _savedObjects := []

func _init(modLoader = ModLoader):
	updateTL("i18n/en.txt", "|")

func _ready():
	l("Readying")
	var layer = load(modPath + "FoxyLayer.tscn").instance()
	var CRoot = get_tree().get_root()
	CRoot.call_deferred("add_child",layer)
	l("Ready")
func updateTL(path:String, delim:String = ",", useRelativePath:bool = true, fullLogging:bool = true):
	if useRelativePath:
		path = str(modPath + path)
	l("Adding translations from: %s" % path)
	var tlFile:File = File.new()
	tlFile.open(path, File.READ)

	var translations := []
	
	var translationCount = 0
	var csvLine := tlFile.get_line().split(delim)
	if fullLogging:
		l("Adding translations as: %s" % csvLine)
	for i in range(1, csvLine.size()):
		var translationObject := Translation.new()
		translationObject.locale = csvLine[i]
		translations.append(translationObject)

	while not tlFile.eof_reached():
		csvLine = tlFile.get_csv_line(delim)

		if csvLine.size() > 1:
			var translationID := csvLine[0]
			for i in range(1, csvLine.size()):
				translations[i - 1].add_message(translationID, csvLine[i].c_unescape())
			if fullLogging:
				l("Added translation: %s" % csvLine)
			translationCount += 1

	tlFile.close()

	for translationObject in translations:
		TranslationServer.add_translation(translationObject)
	l("%s Translations Updated" % translationCount)

# Func to print messages to the logs
func l(msg:String, title:String = MOD_NAME, version:String = str(MOD_VERSION_MAJOR) + "." + str(MOD_VERSION_MINOR) + "." + str(MOD_VERSION_BUGFIX)):
	if not MOD_VERSION_METADATA == "":
		version = version + "-" + MOD_VERSION_METADATA
	Debug.l("[%s V%s]: %s" % [title, version, msg])
