extends Navigation2D



func _ready():
	# Gets the original navigation polygon
	var polygon = $NavigationPolygonInstance.get_navigation_polygon()
	# Loops through each object node
	for child in get_node("../Objects").get_child_count():
		# Gets the object
		var object = get_node("../Objects/Object" + str(child))
		# Creates a new polygon
		var newPolygon = PoolVector2Array()
		# Gets the outline of the NavOutline CollisionPolygon2D
		var polygonTransform = object.get_node("NavOutline").get_global_transform()
		var polygonBP = object.get_node("NavOutline").get_polygon()
		# Designates where to cut in the new polygon
		for vertex in polygonBP:
			newPolygon.append(polygonTransform.xform(vertex))
		# Cuts out the outline in the original polygon
		polygon.add_outline(newPolygon)
		polygon.make_polygons_from_outlines()
	# Sets the former original now modified polygon as the actual NavigationPolygon
	$NavigationPolygonInstance.set_navigation_polygon(polygon)
	# It has to do this or it won't update.
	$NavigationPolygonInstance.enabled = false
	$NavigationPolygonInstance.enabled = true

