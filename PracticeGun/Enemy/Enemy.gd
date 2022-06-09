extends KinematicBody2D
class_name enemy, "res://skull.png"

# https://www.davidepesce.com/2019/11/12/godot-tutorial-10-monsters-and-artificial-intelligence/

# Get Enemy Stats
export var health = 100
export var speed = 50
export var team = 0

# Run Away or Not
var Agressive : bool = true

# Goal: Now make it so that it only shoots when in range / view

# Rotate Enemy Weapon
onready var weapon_rotation : Position2D = $Weapon_Rotation

# Get Enemy Health Bar
onready var health_bar : ProgressBar = $HealthBar

# Get Player Node
onready var player : KinematicBody2D = get_tree().current_scene.get_node("Player")

# Get all enemies
onready var enemies_node = get_tree().current_scene.get_node("Enemies")

# Path Finding
onready var navigation : Navigation2D = get_tree().current_scene.get_node("PathFind")
var path : PoolVector2Array
var go_next = Vector2(0, 0)

# The Enemy Will Focus on This Kinematic Body
var focus_on_this : KinematicBody2D
var can_focus = false

# Signal
signal get_player

# Can See Player
var CanSee : bool = true

func _ready():
	health_bar.value = health
	health_bar.max_value = health
	
	_on_TargetThing_timeout()

func _physics_process(delta):
	
	if (can_focus):
		new_focus()
		can_focus = false
	
	if (CanSee):
		
		weapon_rotation()
		if (Agressive):
			chase(1)
		else:
			chase(-1)
		
		move_and_slide(go_next * speed * delta)



func chase(fight_flight):
	if path:
		var vector_to_next_point: Vector2 = path[0] - global_position
		var distance_to_next_point: float = vector_to_next_point.length()
		if distance_to_next_point < 3:
			path.remove(0)
			if not path:
				return
		go_next = vector_to_next_point * fight_flight


func weapon_rotation():
	if is_instance_valid(focus_on_this):
		if (focus_on_this == player):
			rotate_at_this(player)
		else:
			rotate_at_this(focus_on_this)

func rotate_at_this(subject_to_rotate_at):
	weapon_rotation.rotation = 0
	var mpos = subject_to_rotate_at.global_position
	var ang = weapon_rotation.get_angle_to(mpos)
	weapon_rotation.rotation = ang


func take_damage(damage):
	health -= damage
	health_bar.value = health
	check_if_dead()

func check_if_dead():
	if (health <= 0):
		queue_free()




func _on_PathTimer_timeout():
	if is_instance_valid(focus_on_this):
		_get_path_to_this()

func _get_path_to_this():
	path = navigation.get_simple_path(global_position, focus_on_this.position)


func _on_TargetThing_timeout():
	can_focus = true


func new_focus():
	var find_this : Array
	
	var total_enemies = enemies_node.get_children()
	
	if is_instance_valid(player):
		total_enemies.append(player)
	
	for i in total_enemies.size():
		if (total_enemies[i].team != team):
			find_this.append(total_enemies[i])
	if (find_this.size() > 0):
		focus_on_this = find_this[randi() % find_this.size()]


func _on_Sensor_body_entered(body):
	if (body is KinematicBody2D):
		if (body.team != team):
			Agressive = false
		


func _on_Sensor_body_exited(body):
	if (body is KinematicBody2D):
		if (body.team != team):
			$Coward.one_shot = true
			$Coward.start()


func _on_Coward_timeout():
	Agressive = true
