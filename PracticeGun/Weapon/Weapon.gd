extends Area2D
class_name weapon

var damage = 10
export var ammo = 10
export var shoot_speed = 0.2
export var ap_cost = 10
var ready_to_attack : bool = true

signal shot_cost

enum type {
	PLAYER, ENEMY
}

onready var Bullet = preload("res://Bullet/Bullet.tscn")
onready var Muzzle : Position2D = $muzzle
onready var AttackTimer : Timer = $AttackTimer

export (type) var user = type.PLAYER

onready var CurrentTupe = user

func _ready():
	AttackTimer.wait_time = shoot_speed

func _process(delta):
	
	if (CurrentTupe == type.PLAYER):
		if (Input.is_action_just_pressed("shoot") && visible && ready_to_attack):
			shoot_gun()
			ready_to_attack = false
	elif (CurrentTupe == type.ENEMY):
		if (ready_to_attack):
			shoot_gun()
			ready_to_attack = false

func shoot_gun():
	var bullet = Bullet.instance()
	bullet.damage += damage
	bullet.transform = Muzzle.global_transform
	get_node("/root").add_child(bullet)
	emit_signal("shot_cost", 0, 0, ap_cost)


func _on_AttackTimer_timeout():
	ready_to_attack = true
	AttackTimer.one_shot = true
	AttackTimer.start()
