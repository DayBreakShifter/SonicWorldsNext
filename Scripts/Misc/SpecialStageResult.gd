extends Node2D

var activated = false

func _ready():
	# set stage text label to the current stage
	$HUD/Stage.text = "Stage "+str(Global.specialStageID+1)
	# cycle through emeralds on the hud
	for i in $HUD/ColorRect/HBoxContainer.get_child_count():
		# compare the bit value of Global.emeralds using a bitwise operation
		# if the emerald isn't collected then hide it
		$HUD/ColorRect/HBoxContainer.get_child(i).get_child(0).visible = (Global.emeralds & (1 << i))
		$HUD/ColorRect/HBoxContainer.get_child(i).get_child(0).play()
	# wait for screen to fade in
	$BGMTimer.start(1)
	await $BGMTimer.timeout
	
	# play bgm regardless of outcome
	$VictoryBGM.play()
	await $VictoryBGM.finished
	
	# win
	if Global.specialStatus == 1:
		emeraldGet()
	
	# fail
	if Global.specialStatus == 2:
		emeraldFail()

func _input(event):
	if !activated:
		# set to win
		if event.is_action_pressed("gm_action"):
			emeraldGet()
			
			
		if event.is_action_pressed("gm_action2"):
			emeraldFail()

func emeraldGet():
	# set binary bit of current emerald (using the special stage ID)
	Global.emeralds = Global.emeralds | (1 << Global.specialStageID)
	activated = true
	# play emerald jingle
	$Emerald.play()
	# show current stages emerald
	$HUD/ColorRect/HBoxContainer.get_child(Global.specialStageID).get_child(0).visible = true
	await $Emerald.finished
	next_stage()
	Global.main.change_scene_to_file(null,"WhiteOut","",1,true,false)

func emeraldFail():
	activated = true
	next_stage()
	Global.main.change_scene_to_file(null,"WhiteOut","",1,true,false)

func next_stage():
	# set inSpecialStage flag to false
	Global.inSpecialStage = false
	# reset result of special stage
	Global.specialStatus = 0
	# done a loop ensures that the while loop executes at least once
	var doneALoop = false
	# if emeralds less then 127 (all 7 emeralds collected in binary)
	# check that there isn't already an emerald collected on current stage
	while Global.emeralds < 127 and (Global.emeralds & (1 << Global.specialStageID) or !doneALoop):
		Global.specialStageID = wrapi(Global.specialStageID+1,0,7)
		doneALoop = true
