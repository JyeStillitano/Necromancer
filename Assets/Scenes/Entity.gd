extends CharacterBody2D

@export var speed: float = 100
var chase_target: Node2D
var attack_target: Node2D
var current_state: State

@onready var animations: AnimatedSprite2D = $AnimatedSprite

enum State {
	Idle,
	Chase,
	Attack,
	Search,
	Patrol,
	Hit,
	React
}

func _ready() -> void:
	change_state(State.Idle)
	animations.play("Idle")
	print(animations)

func _physics_process(delta):
	match current_state:
		State.Chase: chase()
		State.Attack: attack()

# ATTACK ===========================================================
func attack():
	pass

# CHASE ==============================================================
func chase():
	if chase_target: 
		var direction = (chase_target.global_position - global_position).normalized()
		
		velocity = direction * speed
		move_and_slide()

# MANAGE STATE =====================================================
func change_state(state: State) -> void:
	animations.stop()
	
	match state:
		State.Idle: 
			animations.play("Idle")
			current_state = State.Idle
		State.Chase:
			animations.play("Walk")
			current_state = State.Chase
		State.Attack:
			animations.play("Attack")
			current_state = State.Attack
		State.Search:
			animations.play("Walk")
			current_state = State.Search
		State.Patrol:
			animations.play("Walk")
			current_state = State.Patrol
		State.Hit:
			animations.play("Hit")
			current_state = State.Hit
		State.React:
			animations.play("React")
			current_state = State.React

# AGRO LISTENERS ===================================================
func _on_agro_area_body_entered(body: Node2D):
	#if state == State.IDLE:
		chase_target = body
		change_state(State.Chase)

func _on_agro_area_body_exited(body):
	if current_state == State.Chase: 
		change_state(State.Idle)
		chase_target = null

# ATTACK LISTENERS ===================================================
func _on_attack_area_body_entered(body: Node2D):
	attack_target = body
	change_state(State.Attack)

func _on_attack_area_body_exited(body: Node2D):
	# Remove target if out of range.
	if body == attack_target:
		attack_target = null
		
		# If there are other attackable entities, change target
		var targets: Array = $AttackArea.get_overlapping_bodies() 
		if targets.size() > 0:
			attack_target = targets[0]
		# Else, chase target.
		else:
			chase_target = body
			change_state(State.Chase)
