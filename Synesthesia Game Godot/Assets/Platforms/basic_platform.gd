extends Node

@export var drop_amount = 30.0
@export var drop_time = 2.0

var is_moving = false
var move_again = false
# Called when the node enters the scene tree for the first time.

var timer = 0
var init_y
var drop_y

func cubic_solver(a: float, b: float, c: float, d: float) -> Array:
	var roots = []
	var f = ((3.0 * c / a) - ((b * b) / (a * a))) / 3.0
	var g = ((2.0 * b * b * b) / (a * a * a) - (9.0 * b * c) / (a * a) + (27.0 * d) / a) / 27.0
	var h = (g * g / 4.0) + (f * f * f / 27.0)

	if f == 0 and g == 0 and h == 0:
		roots.append(-pow(d / a, 1.0 / 3.0))
	elif h <= 0:
		var i = sqrt((g * g / 4.0) - h)
		var j = pow(i, 1.0 / 3.0)
		var k = acos(-g / (2.0 * i))
		var l = j * -1
		var m = cos(k / 3.0)
		var n = sqrt(3) * sin(k / 3.0)
		var p = (b / (3.0 * a)) * -1

		roots.append(2 * j * cos(k / 3.0) - (b / (3.0 * a)))
		roots.append(l * (m + n) + p)
		roots.append(l * (m - n) + p)
	elif h > 0:
		var r = -g / 2.0 + sqrt(h)
		var s = pow(r, 1.0 / 3.0)
		var t = -g / 2.0 - sqrt(h)
		var u = pow(abs(t), 1.0 / 3.0)
		u *= -1 if t < 0 else 1
		roots.append((s + u) - b / (3.0 * a))
		
	return roots

# A function to find the smallest real root of a cubic equation given specific parameters
func find_smallest_root(p: float, s: float, y: float) -> float:
	# Convert the specific cubic equation to the standard form
	var a = s / (2.0 * p)
	var b = -2.0 * s
	var c = 2.0 * s * p
	var d = -y * p * p * p
	print(a," ", b," ", c," ", d)
	# Solve the cubic equation
	var roots = cubic_solver(a, b, c, d)
	
	# Filter out complex roots and find the smallest real root
	var smallest_real_root = INF
	for root in roots:
		if typeof(root) == TYPE_FLOAT and root < smallest_real_root:
			smallest_real_root = root
	
	# If no real root was found, return NaN (Not a Number)
	if smallest_real_root == INF:
		print("No real root found.")
		return 0
	
	return smallest_real_root

func _ready():
	drop_y = self.position.y - drop_amount
	print(drop_y)
	init_y = self.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_moving:
		timer += delta
		#print("timer: %s", timer)
		self.position.y = init_y + (drop_amount*timer*(timer - drop_time)**2)/drop_time**3
	if move_again:
		timer = find_smallest_root(drop_time , drop_amount, (drop_amount*timer*(timer - drop_time)**2)/drop_time**3)
		#print("new timer: %s", timer)
		move_again = false
	if timer >= drop_time:
		is_moving = false
		timer = 0

func _on_area_2d_body_entered(body):
	if is_moving:
		move_again = true
	else:
		is_moving = true
