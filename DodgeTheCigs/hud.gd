extends CanvasLayer

signal start_game

func _ready():
	$StartButton.grab_focus()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func generate_insult():
	var insult_array = ["Dork", "Loser", "Idiot", "Dickhead", "Fuckwit"]
	var insult = insult_array[randi() % insult_array.size()]
	
	return insult

func show_game_over():
	show_message("Fuck")
	
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the\nCigs"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$StartButton.grab_focus()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


