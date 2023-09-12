extends CharacterBody3D

# Tekan node dan arahkan ke scrip, Lepaskan sambil menekan CTRL
@onready var sudut_pandangan = $"Sudut Pandangan"
@onready var animation_player = $Model/mixamo_base/AnimationPlayer
@onready var model = $Model

var SPEED = 3.0
const JUMP_VELOCITY = 4.5
var kecepatan_berjalan = 3.0
var kecepatan_berlari = 5.0
var lari = false
var dikunci = false
#@export Untuk menampilkan di dalam Inspetur agar lebih mudah di edit
@export var sensivitas_horizontal = 0.2
@export var sensivitas_vertikal = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
# di Tambahkan manual untuk menghentikan mouse :
#func _ready():
#	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
# di Tambahkan manual untuk rotasi Penglihatan dengan mouse :
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x*sensivitas_horizontal))
		model.rotate_y(deg_to_rad(event.relative.x*sensivitas_horizontal))
		sudut_pandangan.rotate_x(deg_to_rad(event.relative.y*sensivitas_vertikal))
	
func _physics_process(delta):
	if !animation_player.is_playing():
		dikunci = false
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Aksi serangan
	if Input.is_action_just_pressed("serang"):
		if animation_player.current_animation != "serang":
			animation_player.play("kick")
			dikunci = true
	if Input.is_action_just_pressed("serang"):
		if animation_player.current_animation != "serang":
			animation_player.play("kick")
			dikunci = true
	# Aksi berlari
	if Input.is_action_pressed("lari"):
		SPEED = kecepatan_berlari
		lari = true
	else:
		SPEED = kecepatan_berjalan
		lari = false
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis *delta* Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !dikunci:
			if lari:
				if animation_player.current_animation != "running":
					animation_player.play("running")
				
			else:	
				if animation_player.current_animation != "walking":
					animation_player.play("walking")
		if !dikunci:
			model.look_at(position + direction)
			
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if !dikunci:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if !dikunci:
		move_and_slide()
