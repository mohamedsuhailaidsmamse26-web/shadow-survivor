
extends CanvasLayer

func _ready() -> void:
    create_title()
    create_mobile_controls()


func create_title() -> void:
    var title := Label.new()
    title.text = "SHADOW SURVIVOR"
    title.position = Vector2(20, 20)
    title.add_theme_font_size_override("font_size", 24)
    title.add_theme_color_override("font_color", Color.WHITE)
    add_child(title)


func create_mobile_controls() -> void:
    create_button("▲", "move_forward", Vector2(100, 430))
    create_button("▼", "move_backward", Vector2(100, 530))
    create_button("◀", "move_left", Vector2(25, 480))
    create_button("▶", "move_right", Vector2(175, 480))
    create_button("RUN", "run", Vector2(270, 530))
    create_button("JUMP", "jump", Vector2(270, 430))


func create_button(
    button_text: String,
    action_name: String,
    button_position: Vector2
) -> void:
    var button := Button.new()

    button.text = button_text
    button.position = button_position
    button.custom_minimum_size = Vector2(65, 60)

    button.add_theme_font_size_override("font_size", 18)
    button.modulate = Color(0.75, 0.85, 1.0, 0.9)

    button.button_down.connect(
        _on_button_down.bind(action_name)
    )

    button.button_up.connect(
        _on_button_up.bind(action_name)
    )

    add_child(button)


func _on_button_down(action_name: String) -> void:
    Input.action_press(action_name)


func _on_button_up(action_name: String) -> void:
    Input.action_release(action_name)
