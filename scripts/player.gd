
extends CharacterBody3D

const WALK_SPEED := 4.0
const RUN_SPEED := 7.0
const JUMP_VELOCITY := 4.5
const GRAVITY := 9.8

func _ready() -> void:
    setup_controls()

    var collision = get_node_or_null("CollisionShape3D")
    if collision:
        collision.position.y = 0.9

    var body_mesh := MeshInstance3D.new()
    body_mesh.name = "PlayerVisual"

    var capsule := CapsuleMesh.new()
    capsule.radius = 0.4
    capsule.height = 1.8

    body_mesh.mesh = capsule
    body_mesh.position.y = 0.9

    var material := StandardMaterial3D.new()
    material.albedo_color = Color(0.12, 0.16, 0.22)
    body_mesh.material_override = material

    add_child(body_mesh)


func setup_controls() -> void:
    add_key_action("move_forward", KEY_W)
    add_key_action("move_backward", KEY_S)
    add_key_action("move_left", KEY_A)
    add_key_action("move_right", KEY_D)
    add_key_action("run", KEY_SHIFT)
    add_key_action("jump", KEY_SPACE)


func add_key_action(action_name: String, key: Key) -> void:
    if not InputMap.has_action(action_name):
        InputMap.add_action(action_name)

    var event := InputEventKey.new()
    event.physical_keycode = key
    InputMap.action_add_event(action_name, event)


func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= GRAVITY * delta

    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    var input_dir := Input.get_vector(
        "move_left",
        "move_right",
        "move_forward",
        "move_backward"
    )

    var direction := Vector3(input_dir.x, 0, input_dir.y)

    if direction.length() > 0:
        direction = direction.normalized()

    var camera := get_node_or_null("Camera3D")

    if camera:
        direction = camera.global_basis * direction
        direction.y = 0
        direction = direction.normalized()

    var speed := RUN_SPEED if Input.is_action_pressed("run") else WALK_SPEED

    velocity.x = direction.x * speed
    velocity.z = direction.z * speed

    move_and_slide()
