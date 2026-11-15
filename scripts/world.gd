
extends Node3D

func _ready() -> void:
    create_environment()
    create_ground()
    create_buildings()


func create_environment() -> void:
    var world_environment := WorldEnvironment.new()
    var environment := Environment.new()

    environment.background_mode = Environment.BG_SKY

    var sky := Sky.new()
    var sky_material := ProceduralSkyMaterial.new()
    sky_material.sky_top_color = Color(0.025, 0.045, 0.09)
    sky_material.sky_horizon_color = Color(0.18, 0.22, 0.3)
    sky.sky_material = sky_material

    environment.sky = sky
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color(0.45, 0.5, 0.65)
    environment.ambient_light_energy = 0.7

    world_environment.environment = environment
    add_child(world_environment)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-45, -30, 0)
    sun.light_energy = 1.2
    add_child(sun)


func create_ground() -> void:
    var ground := StaticBody3D.new()
    ground.name = "Ground"

    var mesh_instance := MeshInstance3D.new()
    var mesh := PlaneMesh.new()
    mesh.size = Vector2(200, 200)
    mesh_instance.mesh = mesh

    var material := StandardMaterial3D.new()
    material.albedo_color = Color(0.12, 0.14, 0.13)
    material.roughness = 1.0
    mesh_instance.material_override = material

    ground.add_child(mesh_instance)

    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = Vector3(200, 0.2, 200)
    collision.shape = shape
    collision.position.y = -0.1

    ground.add_child(collision)
    add_child(ground)


func create_buildings() -> void:
    for i in range(12):
        var building := StaticBody3D.new()
        building.name = "Building_" + str(i)

        var height := randf_range(5.0, 16.0)
        var width := randf_range(5.0, 9.0)

        var mesh_instance := MeshInstance3D.new()
        var mesh := BoxMesh.new()
        mesh.size = Vector3(width, height, 8)
        mesh_instance.mesh = mesh

        var material := StandardMaterial3D.new()
        material.albedo_color = Color(0.12, 0.15, 0.2)
        mesh_instance.material_override = material
        mesh_instance.position.y = height / 2.0

        building.add_child(mesh_instance)

        var collision := CollisionShape3D.new()
        var shape := BoxShape3D.new()
        shape.size = Vector3(width, height, 8)
        collision.shape = shape
        collision.position.y = height / 2.0

        building.add_child(collision)

        building.position = Vector3(
            float(i % 4) * 18.0 - 27.0,
            0,
            -float(i / 4) * 18.0 - 15.0
        )

        add_child(building)
