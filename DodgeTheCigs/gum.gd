extends RigidBody2D

func explode():
	$ExplodeArea/CollisionShape2D.set_deferred("disabled", false)
	await get_tree().create_timer(0.05).timeout
	queue_free()

func _on_explode_area_body_entered(body):
	if body.is_in_group("mobs"):
		body.die()
