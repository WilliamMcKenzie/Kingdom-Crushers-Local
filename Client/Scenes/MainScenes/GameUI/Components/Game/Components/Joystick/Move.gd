class_name MoveJoystick

extends Control

# https://github.com/MarcoFazioRandom/Virtual-Joystick-Godot

#### EXPORTED VARIABLE ####

# The color of the button when the joystick is in use.
export(Color) var pressed_color := Color.gray

# If the input is inside this range, the output is zero.
export(float, 0, 200, 1) var deadzone_size : float = 10

# The max distance the tip can reach.
export(float, 0, 100, 1) var clampzone_size : float = 75

# FIXED: The joystick doesn't move.
# DYNAMIC: Every time the joystick area is pressed, the joystick position is set on the touched position.
enum JoystickMode {FIXED, DYNAMIC}

export(JoystickMode) var joystick_mode := JoystickMode.DYNAMIC

# VISIBILITY_ALWAYS = Always visible.
# VISIBILITY_TOUCHSCREEN_ONLY = Visible on touch screens only.
enum VisibilityMode {ALWAYS , TOUCHSCREEN_ONLY }

export(VisibilityMode) var visibility_mode := VisibilityMode.ALWAYS

#### PUBLIC VARIABLES ####

# If the joystick is receiving inputs.
var _pressed := false setget , is_pressed

func is_pressed() -> bool:
	return _pressed

#### PRIVATE VARIABLES ####

var _touch_index : int = -1

onready var _base := $Base
onready var _tip := $Base/Tip

onready var _base_radius = _base.rect_size * _base.get_global_transform_with_canvas().get_scale() / 2

onready var _base_default_position : Vector2 = _base.rect_position
onready var _tip_default_position : Vector2 = _tip.rect_position

onready var _default_color : Color = _tip.modulate

func _ready() -> void:
	if not OS.has_touchscreen_ui_hint() and visibility_mode == VisibilityMode.TOUCHSCREEN_ONLY:
		hide()

func _physics_process(delta):
	if SettingsHandler.joysticks:
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,1,1,0)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_point_inside_joystick_area(event.position) and _touch_index == -1 and not GameUI.focused:
				visible = true
				if joystick_mode == JoystickMode.DYNAMIC or (joystick_mode == JoystickMode.FIXED and _is_point_inside_base(event.position)):
					if joystick_mode == JoystickMode.DYNAMIC:
						_move_base(event.position)
					_touch_index = event.index
					_update_joystick(event.position)
		elif event.index == _touch_index:
			_reset()
	elif event is InputEventScreenDrag:
		if event.index == _touch_index:
			_update_joystick(event.position)

func _move_base(new_position: Vector2) -> void:
	_base.rect_global_position = new_position - _base.rect_pivot_offset * get_global_transform_with_canvas().get_scale()

func _move_tip(new_position: Vector2) -> void:
	_tip.rect_global_position = new_position - _tip.rect_pivot_offset * _base.get_global_transform_with_canvas().get_scale()

func _is_point_inside_joystick_area(point: Vector2) -> bool:
	var viewport_width = get_viewport().get_visible_rect().size.x
	return point.x < viewport_width / 2

func _is_point_inside_base(point: Vector2) -> bool:
	var center : Vector2 = _base.rect_global_position + _base_radius
	var vector : Vector2 = point - center
	if vector.length_squared() <= _base_radius.x * _base_radius.x:
		return true
	else:
		return false

func _update_joystick(touch_position: Vector2) -> void:
	var center : Vector2 = _base.rect_global_position + _base_radius/2
	var vector : Vector2 = touch_position - center
	vector = vector.clamped(clampzone_size)
	
	_move_tip(center + vector)
	
	if vector.length_squared() > deadzone_size * deadzone_size:
		_pressed = true
		GameUI.move_joystick = (vector - (vector.normalized() * deadzone_size)) / (clampzone_size - deadzone_size)
	else:
		_pressed = false
		GameUI.move_joystick = Vector2.ZERO

func _reset():
	visible = false
	_pressed = false
	GameUI.move_joystick = Vector2.ZERO
	_touch_index = -1
	_tip.modulate = _default_color
	_base.rect_position = _base_default_position
	_tip.rect_position = _tip_default_position
