extends KinematicBody2D

var char_Sheet = {
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
var av = Vector2.ZERO  # Avoidance vector.
var avoidWeight = 0.1  # How strongly to avoid other units.
var targetRadius = 50  # Stop when this close to target.
var target = null setget set_target  # Set this to move.
var selected = false setget setSelected  # Is this unit selected?
var velocity = Vector2.ZERO

func _Calc_Scores():
	speed = 0
	
var rand = RandomNumberGenerator.new()
func _Rand_Scores():
	rand.randomize()
	char_Sheet.Attr.Str = rand.randf_range(1.0, 10.0)
	
func _ready():
	# Make sure the material is unique to this unit.
	$Sprite.material = $Sprite.material.duplicate()
	_Rand_Scores()
	_Calc_Scores()
	
func _physics_process(delta):
	update()

func setSelected(value):
	# Draw a highlight around the unit if it's selected.
	selected = value
	if selected:
		$Sprite.material.set_shader_param("aura_width", 1)
	else:
		$Sprite.material.set_shader_param("aura_width", 0)
		
func set_target(value):
	target = value

	
func _draw():
	# Draws some debug vectors.
	if !DEBUG_DRAW:
		return
	draw_circle(Vector2.ZERO, $Detect/CollisionShape2D.shape.radius,
				Color(0.0, (char_Sheet.Attr.Str / 10), 0, 0.5))
