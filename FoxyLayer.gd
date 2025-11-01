extends CanvasLayer

export var playing = false
var config_exists = false
var rng = RandomNumberGenerator.new()
var cfg = null
var ConfigDriver = preload("res://HevLib/pointers/ConfigDriver.gd")
func _ready():
	var dir = Directory.new()
	if dir.file_exists("res://HevLib/pointers/ConfigDriver.gd"):
		config_exists = true
		cfg = load("res://HevLib/pointers/ConfigDriver.gd")
	else:
		config_exists = false

func clear():
	$Sprite.frame = 0
	$AnimationPlayer.stop()

func start():
	var size = Settings.getViewportSize()
	var newscale = size.x / 1024
#	var newOffset = float(size.x - 1024) / 2
	$Sprite.scale.x = newscale
	$Sprite.scale.y = newscale
#	offset.x = newOffset
	
	$Sprite.frame = 0
	$AnimationPlayer.play("fox")
	$AudioStreamPlayer.seek(0.0)
	$AudioStreamPlayer.play()

func calculate_chance():
	var chance = 10000
	if config_exists:
		var configuration = cfg.__get_config("1in10,000ChanceWitheredFoxyJumpscareEverySecond").get("FOXYJUMPSCARE_CFG",{})
		chance = configuration.get("jumpscare_chance",10000)
		interval = configuration.get("interval",1)
	var c = rng.randi_range(1,chance)
	if c <= 1:
		start()
	
var interval = 1
var count = 0
func _physics_process(delta):
	count += delta
	if count >= interval:
		count = 0.0
		if not playing:
			calculate_chance()

