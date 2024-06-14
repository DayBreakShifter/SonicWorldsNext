extends PlayerState

var activated = true

func _process(_delta):
	if activated and !parent.isSuper:
		var remVel = parent.movement
		var lastAnim = parent.animator.current_animation
		# hide shield
		parent.shieldSprite.visible = false
		# set movement to 0
		parent.movement = Vector2.ZERO
		activated = false
		
		# play super animation
		parent.sfx[18].play()
		parent.animator.play("super")
		get_node("../../../HUD/SuperFlash/SuperFlashAnim").play("SuperFlash")
		
		# wait for aniamtion to finish before activating super completely
		await parent.animator.animation_finished
		
		# Update Discord Player Icons
		match(Global.PlayerChar1):
			Global.CHARACTERS.SONIC:
				discord_sdk.small_image = "charhead-sonic_super"
			Global.CHARACTERS.TAILS:
				discord_sdk.small_image = "charhead-tails_super"
			Global.CHARACTERS.KNUCKLES:
				discord_sdk.small_image = "charhead-knuckles_super"
			Global.CHARACTERS.AMY:
				discord_sdk.small_image = "charhead-amy_super"
			#Global.CHARACTERS.CREAM:
			#	discord_sdk.small_image = "charhead-cream_super"
			Global.CHARACTERS.XANDER:
				discord_sdk.small_image = "charhead-xander_super"
		discord_sdk.refresh()
		
		if parent.ground:
			parent.animator.play(lastAnim)
		else:
			parent.animator.play("walk")
		# enable control again
		parent.set_state(parent.STATES.AIR)
		activated = true
		
		# start super theme
		Global.currentTheme = 0
		Global.effectTheme.stream = Global.themes[Global.currentTheme]
		Global.effectTheme.play()
		# swap sprite if sonic
		if parent.character == parent.CHARACTERS.SONIC:
			parent.sprite.texture = parent.superSprite
		# reset velocity to memory
		parent.movement = remVel
		parent.isSuper = true
		parent.switch_physics()
		parent.supTime = 1
	# if already super just go to air state
	elif parent.isSuper:
		parent.set_state(parent.STATES.AIR)
		

func state_exit():
	activated = true
