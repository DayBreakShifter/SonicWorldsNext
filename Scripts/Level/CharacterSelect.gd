extends Node2D


@export var music = preload("res://Audio/Soundtrack/10. SWD_CharacterSelect.ogg")
@export var nextZone = load("res://Scene/Zones/BaseZone.tscn")
var selected = false

# character labels, the amount of labels in here determines the total amount of options, see the set character option at the end for settings
var characterLabels = ["Sonic and Tails", "Sonic the Hedgehog", "Miles \"Tails\" Prower", "Knuckles the Echidna", "Amy Rose", "Xander the Dragon"]
# level labels, the amount of labels in here determines the total amount of options, see set level option at the end for settings
var levelLabels = ["Base Zone Act 1", "Base Zone Act 2", "Chunk Zone Act 1"]
# character id lines up with characterLabels
var characterID = 0
# level id lines up with levelLabels
var levelID = 0

func _ready():
	Global.music.stream = music
	Global.music.play()
	$UI/Labels/Control/Character.text = characterLabels[characterID]
	if nextZone != null:
		Global.nextZone = nextZone

func _input(event):
	if !selected:
		# select character rotation
		if Input.is_action_just_pressed("gm_left"):
			characterID = wrapi(characterID-1,0,characterLabels.size())
		if Input.is_action_just_pressed("gm_right"):
			characterID = wrapi(characterID+1,0,characterLabels.size())
		if Input.is_action_just_pressed("gm_down"):
			levelID = wrapi(levelID+1,0,levelLabels.size())
		if Input.is_action_just_pressed("gm_up"):
			levelID = wrapi(levelID-1,0,levelLabels.size())
		
		$UI/Labels/Control/Character.text = characterLabels[characterID]
		$UI/Labels/Control/Level.text = levelLabels[levelID]
		
		# turn on and off visibility of the characters based on the current selection
		match(characterID):
			0: # Sonic and Tails
				$UI/Labels/CharacterOrigin/Sonic.visible = true
				$UI/Labels/CharacterOrigin/Sonic.position.x = 13
				$UI/Labels/CharacterOrigin/Tails.visible = true
				$UI/Labels/CharacterOrigin/Tails.position.x = -9
				$UI/Labels/CharacterOrigin/Knuckles.visible = false
				$UI/Labels/CharacterOrigin/Amy.visible = false
			1: # Sonic
				$UI/Labels/CharacterOrigin/Sonic.visible = true
				$UI/Labels/CharacterOrigin/Sonic.position.x = 1
				$UI/Labels/CharacterOrigin/Tails.visible = false
				$UI/Labels/CharacterOrigin/Knuckles.visible = false
				$UI/Labels/CharacterOrigin/Amy.visible = false
			2: # Tails
				$UI/Labels/CharacterOrigin/Sonic.visible = false
				$UI/Labels/CharacterOrigin/Tails.visible = true
				$UI/Labels/CharacterOrigin/Tails.position.x = 3
				$UI/Labels/CharacterOrigin/Knuckles.visible = false
				$UI/Labels/CharacterOrigin/Amy.visible = false
			3: # Knuckles
				$UI/Labels/CharacterOrigin/Sonic.visible = false
				$UI/Labels/CharacterOrigin/Tails.visible = false
				$UI/Labels/CharacterOrigin/Knuckles.visible = true
				$UI/Labels/CharacterOrigin/Amy.visible = false
			4: # Amy
				$UI/Labels/CharacterOrigin/Sonic.visible = false
				$UI/Labels/CharacterOrigin/Tails.visible = false
				$UI/Labels/CharacterOrigin/Knuckles.visible = false
				$UI/Labels/CharacterOrigin/Amy.visible = true
			5: # Xander
				$UI/Labels/CharacterOrigin/Sonic.visible = false
				$UI/Labels/CharacterOrigin/Tails.visible = false
				$UI/Labels/CharacterOrigin/Knuckles.visible = false
				$UI/Labels/CharacterOrigin/Amy.visible = false
		
		# finish character select if start is pressed
		if event.is_action_pressed("gm_pause"):
			selected = true
			# set player 2 to none to prevent redundant code
			Global.PlayerChar2 = Global.CHARACTERS.NONE
			
			# set the character and update discord
			match(characterID):
				0: # Sonic and Tails
					Global.PlayerChar1 = Global.CHARACTERS.SONIC
					Global.PlayerChar2 = Global.CHARACTERS.TAILS
					#discord_sdk.small_image = "charhead-sonic"
				1: # Sonic
					Global.PlayerChar1 = Global.CHARACTERS.SONIC
					#discord_sdk.small_image = "charhead-sonic"
				2: # Tails
					Global.PlayerChar1 = Global.CHARACTERS.TAILS
					#discord_sdk.small_image = "charhead-tails"
				3: # Knuckles
					Global.PlayerChar1 = Global.CHARACTERS.KNUCKLES
					#discord_sdk.small_image = "charhead-knuckles"
				4: # Amy
					Global.PlayerChar1 = Global.CHARACTERS.AMY
					#discord_sdk.small_image = "charhead-amy"
				5: # Xander
					Global.PlayerChar1 = Global.CHARACTERS.XANDER
					#discord_sdk.small_image = "charhead-xander"
			
			# Update Discord Player Icons
			#discord_sdk.small_image_text = "Playing as " + characterLabels[characterID]
			#discord_sdk.refresh()
					
			# set the level
			match(levelID):
				0: # Base Zone Act 1
					Global.nextZone = load("res://Scene/Zones/BaseZone.tscn") # unnecessary since it's arleady set
				1: # Base Zone Act 2
					Global.nextZone = load("res://Scene/Zones/BaseZoneAct2.tscn") # Replace me! I don't exist yet!
				#2: # Chunk Zone Act 1
				#	Global.nextZone = load("res://Scene/Zones/ChunkZone.tscn")
			
			Global.main.change_scene_to_file(Global.nextZone,"FadeOut","FadeOut",1)
