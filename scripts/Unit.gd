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
var av = Vector2.ZERO  # Avoidance vector.
var avoidWeight = 0.1  # How strongly to avoid other units.
var targetRadius = 50  # Stop when this close to target.
var target = null setget set_target  # Set this to move.
var selected = false setget setSelected  # Is this unit selected?
var velocity = Vector2.ZERO
var rand = RandomNumberGenerator.new()

func _calcScores():
	speed = charSheet.Attr.Dex * 50
	
func _randScores():
	rand.randomize()
	charSheet.Attr.Dex = rand.randf_range(1.0, 10.0)
	
func _ready():
	# Make sure the material is unique to this unit.
	$Sprite.material = $Sprite.material.duplicate()
	_randScores()
	_calcScores()
	
func _physics_process(delta):
	velocity = Vector2.ZERO
	if target:
		# If there's a target, move toward it.
		velocity = position.direction_to(target)
		if position.distance_to(target) < targetRadius:
			target = null
	# Find avoidance vector and add to velocity.
	av = avoid()
	velocity = (velocity + av * avoidWeight).normalized()
	if velocity.length() > 0:
		# Rotate body to point in movement direction.
		rotation = velocity.angle()
	var collision = move_and_collide(velocity * speed * delta)
	update()

func setSelected(value):
	# Draw a highlight around the unit if it's selected.
	selected = value
	if selected:
		$Sprite.material.set_shader_param("auraWidth", 1)
	else:
		$Sprite.material.set_shader_param("auraWidth", 0)
		
func set_target(value):
	target = value

func avoid():
	# Calculates avoidance vector based on nearby units.
	var result = Vector2.ZERO
	var neighbors = $Detect.get_overlapping_bodies()
	if !neighbors:
		return result
	for n in neighbors:
		result += n.position.direction_to(position)
	result /= neighbors.size()
	return result.normalized()
	
func _draw():
	# Draws some debug vectors.
	if !DEBUG_DRAW:
		return
	draw_circle(Vector2.ZERO, $Detect/CollisionShape2D.shape.radius,
				Color((charSheet.Attr.Dex / 10), 0.0, 0, 0.5))
	draw_line(Vector2.ZERO, av.rotated(-rotation)*50, Color(1, 0, 0), 5)
	draw_line(Vector2.ZERO, velocity.rotated(-rotation)*speed, Color(0, 1, 0), 5)
	if target:
		draw_line(Vector2.ZERO, position.direction_to(target).rotated(-rotation)*50,
			Color(0, 0, 1), 5)
