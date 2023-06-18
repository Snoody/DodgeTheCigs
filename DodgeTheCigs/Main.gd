extends Node

@export var mob_scene: PackedScene
@export var gum_scene: PackedScene

var score

var crave_rating

var go_counter = 0

func gum_picked_up(amount, time):
	score += amount
	$HUD.update_score(score)
	if $MobTimer.wait_time < 0.55:
		$MobTimer.wait_time += time


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("gums", "queue_free")
	
	$Music.play()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$GumTimer.stop()
	
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play()

func _on_start_timer_timeout():
	$StartSound.play()
	$MobTimer.start()
	$GumTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_mob_timer_timeout():
	if $MobTimer.wait_time > 0.2:
		$MobTimer.wait_time *= 0.94
	print($MobTimer.wait_time)
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 300.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func _on_gum_timer_timeout():
	$GumTimer.wait_time *= 1.05
	var gum = gum_scene.instantiate()
	
	var gum_spawn_location = get_node("MobPath/GumSpawnLocation")
	gum_spawn_location.progress_ratio = randf()
	
	var direction = gum_spawn_location.rotation + PI / 2
	
	gum.position = gum_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	gum.rotation = randf_range(PI, 0)
	
	var velocity = Vector2(randf_range(120, 160), 0.0)
	gum.linear_velocity = velocity.rotated(direction)
	
	add_child(gum)

func _on_start_sound_finished():
	go_counter += 1
	if go_counter < 3:
		await get_tree().create_timer(0.17).timeout
		$StartSound.play()
	else:
		go_counter = 0
