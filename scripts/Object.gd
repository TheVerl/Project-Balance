extends KinematicBody2D

var charSheet = {
	Name = "John",
	
	Attr = {
		Str = 5,
		Con = 5,
		Dex = 5,
		Int = 5,
		Cha = 5
	}
}

var DEBUG_DRAW = true

export var speed = 100  # Movement speed.
var avoidanceVector = Vector2.ZERO  # Avoidance vector.
var avoidWeight = 0.1  # How strongly to avoid other units.
var targetRadius = 50  # Stop when this close to target.
var target = null setget setTarget  # Set this to move.
var velocity = Vector2.ZERO # The velocity.
var rand = RandomNumberGenerator.new()  # Random number generator.

func _calcScores():
	speed = 0

func _randScores():
	rand.randomize()
	charSheet.Attr.Str = rand.randf_range(1.0, 10.0)
	
func _ready():
	# Make sure the material is unique to this unit.
	$Sprite.material = $Sprite.material.duplicate()
	_randScores()
	_calcScores()
	
func _physics_process(delta):
	update()
		
func setTarget(value):
	target = value

func _draw():
	# Draws some debug vectors.
	if !DEBUG_DRAW:
		return
#	draw_circle(Vector2.ZERO, $Detect/CollisionShape2D.shape.radius,
#				Color(0.0, (charSheet.Attr.Str / 10), 0, 0.5))
