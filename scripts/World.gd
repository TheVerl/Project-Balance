extends Node2D

var dragging = false  # Are we currently dragging?
var selected = []  # Array of currently selected units.
var dragStart = Vector2.ZERO  # Location where drag began.
var selectRect = RectangleShape2D.new()  # Collision shape for drag box.

func _ready():
	pass
	#print(selected.size())

func _process(delta):
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.pressed:
			if selected.size() > 0:
				# Set the path to the destination for each selected unit.
				for item in selected:
					var path = $Navigation2D.get_simple_path(item.collider.position, event.position)
					item.collider.get_node("Line2D").points = path
					item.collider.path = path
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			# Drag and deselect current selection
				dragging = true
				dragStart = event.position
				for item in selected:
					item.collider.selected = false
				selected = []
		# Button released while dragging.
		elif dragging:
			dragging = false
			update()
			var drag_end = event.position
			# Extents are measured from center.
			selectRect.extents = (drag_end - dragStart) / 2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(selectRect)
			query.transform = Transform2D(0, (drag_end + dragStart) / 2)
			# Result is an array of dictionaries. Each has a "collider" key.
			selected = space.intersect_shape(query)
			for item in selected:
				if "Unit" in item.collider.name:
					print(item.collider.name)
					item.collider.selected = true
				else:
					selected.erase(item)

	if event is InputEventMouseMotion and dragging:
		# Draw the box while dragging.
		update()
				
func _draw():
	if dragging:
		draw_rect(Rect2(dragStart, get_global_mouse_position() - dragStart),
				Color(.5, .5, .5), false)
