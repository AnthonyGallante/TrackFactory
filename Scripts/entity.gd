extends Node2D

@export var VDOP := 1.0
@export var HDOP := 1.0
@export var max_speed := 100.0         # meters_per_second
@export var accuracy := 10.0           # meters
@export var report_frequency := 1.0    # seconds between attempts
@export_range(0.0, 1.0, 0.01) var report_throughput := 0.9 # percentage

@onready var map_node: Node2D = $"../../../Map"

var path_progress: float
var latitude: float
var longitude: float
var velocity: float = 0.0
var acceleration: float = 0.0

var prev_node
var next_node
var pocket_watch

enum STATE {IDLE, CONSTANT_VELOCITY, ACCELERATING, DECELERATING, WAITING, FINISHED}
var state: STATE = STATE.IDLE


func _process(_delta: float) -> void:
	scale = Vector2.ONE / map_node.camera.zoom


# ICON
const GENERIC = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border01.png")
const PEDESTRIAN = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border04.png")
const BOAT = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border14.png")
const PLANE = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border15.png")
const TRAIN = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border16.png")
const AUTOMOBILE = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border13.png")

# EMOTES
const EMOTE_EMPTY = preload("res://Assets/Art/Objects/kenney_emotes-pack/PNG/Vector/Style 1/emote__.png")
const EMOTE_FACE_HAPPY = preload("res://Assets/Art/Objects/kenney_emotes-pack/PNG/Vector/Style 1/emote_faceHappy.png")
const EMOTE_FACE_ANGRY = preload("res://Assets/Art/Objects/kenney_emotes-pack/PNG/Vector/Style 1/emote_faceAngry.png")
const EMOTE_FACE_SAD = preload("res://Assets/Art/Objects/kenney_emotes-pack/PNG/Vector/Style 1/emote_faceSad.png")
const EMOTE_DOTS_1 = preload("res://Assets/Art/Objects/kenney_emotes-pack/PNG/Vector/Style 1/emote_dots1.png")
const EMOTE_DOTS_2 = preload("res://Assets/Art/Objects/kenney_emotes-pack/PNG/Vector/Style 1/emote_dots2.png")
const EMOTE_DOTS_3 = preload("res://Assets/Art/Objects/kenney_emotes-pack/PNG/Vector/Style 1/emote_dots3.png")
const EMOTE_STAR = preload("res://Assets/Art/Objects/kenney_emotes-pack/PNG/Vector/Style 1/emote_star.png")
const EMOTE_ALERT = preload("res://Assets/Art/Objects/kenney_emotes-pack/PNG/Vector/Style 1/emote_alert.png")
const EMOTE_SWIRL = preload("res://Assets/Art/Objects/kenney_emotes-pack/PNG/Vector/Style 1/emote_swirl.png")
