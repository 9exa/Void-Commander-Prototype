extends Node3D

@export var cube_size: float = 1.0
@export var face_color: Color = Color.BLACK
@export var edge_color: Color = Color.WHITE
@export var edge_width: float = 0.02

func _ready():
	create_cube_with_edges()

func create_cube_with_edges():
	# Create the solid cube faces
	var cube_mesh_instance = MeshInstance3D.new()
	add_child(cube_mesh_instance)
	
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(cube_size, cube_size, cube_size)
	cube_mesh_instance.mesh = box_mesh
	
	# Material for solid faces
	var face_material = StandardMaterial3D.new()
	face_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	face_material.albedo_color = face_color
	cube_mesh_instance.material_override = face_material
	
	# Create the edge lines
	var edge_mesh_instance = MeshInstance3D.new()
	add_child(edge_mesh_instance)
	
	var half = cube_size / 2.0
	
	# Define the 8 corners of the cube
	var corners = [
		Vector3(-half, -half, -half),  # 0
		Vector3( half, -half, -half),  # 1
		Vector3( half, -half,  half),  # 2
		Vector3(-half, -half,  half),  # 3
		Vector3(-half,  half, -half),  # 4
		Vector3( half,  half, -half),  # 5
		Vector3( half,  half,  half),  # 6
		Vector3(-half,  half,  half),  # 7
	]
	
	# Define the 12 edges (pairs of corner indices)
	var edges = [
		# Bottom face
		[0, 1], [1, 2], [2, 3], [3, 0],
		# Top face
		[4, 5], [5, 6], [6, 7], [7, 4],
		# Vertical edges
		[0, 4], [1, 5], [2, 6], [3, 7],
	]
	
	# Create line mesh using ImmediateMesh
	var immediate_mesh = ImmediateMesh.new()
	edge_mesh_instance.mesh = immediate_mesh
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	# Add each edge as a line
	for edge in edges:
		immediate_mesh.surface_add_vertex(corners[edge[0]])
		immediate_mesh.surface_add_vertex(corners[edge[1]])
	
	immediate_mesh.surface_end()
	
	# Material for edges
	var edge_material = StandardMaterial3D.new()
	edge_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	edge_material.albedo_color = edge_color
	# Make edges render slightly in front to avoid z-fighting
	edge_material.no_depth_test = true
	edge_mesh_instance.material_override = edge_material
	
	# Optional: Offset edges slightly outward to prevent z-fighting
	edge_mesh_instance.position = Vector3.ZERO
