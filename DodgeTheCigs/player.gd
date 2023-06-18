extends Area2D

signal hit

signal gum_pickup(score, time)

@export var speed = 400

var screen_size

var dead = false

func _ready():
	hide()
	screen_size = get_viewport_rect().size


func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if not dead:
		$AnimatedSprite2D.animation = "walk"
		
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.animation = "shaved"

func start(pos):
	position = pos
	$AnimatedSprite2D.animation = "walk"
	$Smoke.hide()
	dead = false
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
		
		dead = true
		
		$AnimatedSprite2D.animation = "shaved"
		$AnimatedSprite2D.flip_h = false
		
		$Smoke.restart()
		$Smoke.show()
		
		hit.emit()
		
		$CollisionShape2D.set_deferred("disabled", true)
		
	elif body.is_in_group("gums"):
		body.explode()
		$Bingo.play()
		gum_pickup.emit(10, 0.3)
