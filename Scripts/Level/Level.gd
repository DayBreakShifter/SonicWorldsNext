extends Node2D

@export var music = preload("res://Audio/Soundtrack/6. SWD_TLZa1.ogg")
@export var nextZone = load("res://Scene/Zones/BaseZone.tscn")

@export_enum("Bird", "Squirrel", "Rabbit", "Chicken", "Penguin", "Seal", "Pig", "Eagle", "Mouse", "Monkey", "Turtle", "Bear")var animal1 = 0
@export_enum("Bird", "Squirrel", "Rabbit", "Chicken", "Penguin", "Seal", "Pig", "Eagle", "Mouse", "Monkey", "Turtle", "Bear")var animal2 = 1

# Boundries
@export var setDefaultLeft = true
@export var defaultLeftBoundry  = -100000000
@export var setDefaultTop = true
@export var defaultTopBoundry  = -100000000

@export var setDefaultRight = true
@export var defaultRightBoundry = 100000000
@export var setDefaultBottom = true
@export var defaultBottomBoundry = 100000000

@export_subgroup("Result Ranks")
@export var scoreForRankS = 12000
@export var scoreForRankA = 9000
@export var scoreForRankB = 6000
@export var scoreForRankC = 3000
@export var scoreForRankD = 1000

# was loaded is used for room loading, this can prevent overwriting global information, see Global.gd for more information on scene loading
var wasLoaded = false

func _ready():
	# debuging
	if !Global.is_main_loaded:
		return false
	# skip if scene was loaded
	if wasLoaded:
		return false
	
	if setDefaultLeft:
		Global.hardBorderLeft  = defaultLeftBoundry
	if setDefaultRight:
		Global.hardBorderRight = defaultRightBoundry
	if setDefaultTop:
		Global.hardBorderTop    = defaultTopBoundry
	if setDefaultBottom:
		Global.hardBorderBottom  = defaultBottomBoundry
	
	# Update Discord Player Icons
	match(Global.PlayerChar1):
		Global.CHARACTERS.SONIC:
			discord_sdk.small_image = "charhead-sonic"
			discord_sdk.small_image_text = "Playing as Sonic"
		Global.CHARACTERS.TAILS:
			discord_sdk.small_image = "charhead-tails"
			discord_sdk.small_image_text = "Playing as Tails"
		Global.CHARACTERS.KNUCKLES:
			discord_sdk.small_image = "charhead-knuckles"
			discord_sdk.small_image_text = "Playing as Knuckles"
		Global.CHARACTERS.AMY:
			discord_sdk.small_image = "charhead-amy"
			discord_sdk.small_image_text = "Playing as Amy Rose"
		#Global.CHARACTERS.CREAM:
		#	discord_sdk.small_image = "charhead-cream"
			discord_sdk.small_image_text = "Playing as Cream"
		Global.CHARACTERS.XANDER:
			discord_sdk.small_image = "charhead-xander"
			discord_sdk.small_image_text = "Playing as Xander"
	discord_sdk.refresh()
	
	level_reset_data(false)
	
	wasLoaded = true

# used for stage starts, also used for returning from special stages
func level_reset_data(playCard = true):
	# music handling
	if Global.music != null:
		if music != null:
			Global.music.stream = music
			Global.music.play()
			Global.music.stream_paused = false
		else:
			Global.music.stop()
			Global.music.stream = null
	# set next zone
	if nextZone != null:
		Global.nextZone = nextZone
	
	# set pausing to true
	if Global.main != null:
		Global.main.sceneCanPause = true
	# set animals
	Global.animals = [animal1,animal2]
	# set rank score
	Global.scoreRanks = [scoreForRankS, scoreForRankA, scoreForRankB, scoreForRankC, scoreForRankD]
	# if global hud and play card, run hud ready script
	if playCard and is_instance_valid(Global.hud):
		$HUD._ready()
