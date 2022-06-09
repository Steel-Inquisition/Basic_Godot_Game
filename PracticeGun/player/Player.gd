extends KinematicBody2D
class_name this_player

export var speed = 200
export var health = 100
export var mp = 100
export var ap = 100

export var team = 0

onready var weapon_rotation : Position2D = $Weapon_Rotation

onready var HpBar = $ViewPoint/UI/HpBar
onready var MpBar = $ViewPoint/UI/MPBar
onready var ApBar = $ViewPoint/UI/ApBar

onready var get_weapon = $Weapon_Rotation/Weapon
onready var shield = $Weapon_Rotation/Shield

# https://docs.godotengine.org/en/stable/tutorials/physics/using_kinematic_body_2d.html

func _ready():
	HpBar.max_value = health
	HpBar.value = health
	MpBar.max_value = mp
	MpBar.value = mp
	ApBar.max_value = ap
	ApBar.value = ap

func _physics_process(delta):
	player_movement(delta)
	switch_weapons()
	weapon_rotate()

func weapon_rotate():
	# Rotate Towards Mouse
	var mpos = get_global_mouse_position()
	var ang = get_angle_to(mpos)
	weapon_rotation.rotation = ang

func take_damage(damage):
	health -= damage
	HpBar.value = health
	check_if_dead()

func check_if_dead():
	if (health <= 0):
		print("End Game!")

func player_movement(delta):
	var velocity = Vector2(0, 0)
	
	if (Input.is_action_pressed("left")):
		velocity.x += -1
	if (Input.is_action_pressed("right")):
		velocity.x += 1
	if (Input.is_action_pressed("up")):
		velocity.y += -1
	if (Input.is_action_pressed("down")):
		velocity.y += 1
	
	velocity = velocity.normalized() * delta * speed
	
	move_and_collide(velocity)

func switch_weapons():
	if (Input.is_action_just_pressed("switch_tool")):
			get_weapon.visible = !get_weapon.visible
			shield.visible = !shield.visible


func _on_Weapon_shot_cost(bullet, mp_cost, ap_cost):
	mp -= mp_cost
	ap -= ap_cost
	MpBar.value = mp
	ApBar.value = ap
	pass # Replace with function body.


func _on_Enemy_get_player(enemy):
	enemy.rotate_at_this(self)

func _on_Enemy2_get_player():
	pass # Replace with function body.
