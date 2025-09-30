extends Node

var hide_players = false
var hide_player_shots = false
var show_fps = false
var show_ping = false
var interpolation_offset = 100

var zoom = 1
var auto_open_chests = false
var audio = true

var open_inventory = InputEventKey.new()
var enter_dungeon = InputEventKey.new()
var use_ability = InputEventKey.new()
var return_to_port = InputEventKey.new()

var smoothing = true
var joysticks = true
var buttons = true
