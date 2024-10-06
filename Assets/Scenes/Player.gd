extends CharacterBody2D

@export var speed = 200


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("Right"): direction.x += 1
	if Input.is_action_pressed("Left"): direction.x -= 1
	if Input.is_action_pressed("Up"): direction.y -= 1
	if Input.is_action_pressed("Down"): direction.y += 1
	
	if direction.x != 0: $AnimatedSprite.flip_h = direction.x < 0
	if direction != Vector2.ZERO: $AnimatedSprite.play("Walk")
	else: $AnimatedSprite.play("Idle")
	
	# Normalize direction vector to maintain consistent speed
	velocity = direction.normalized() * speed
	
	# Apply force to the Rigidbody2D
	move_and_slide()
	pass
