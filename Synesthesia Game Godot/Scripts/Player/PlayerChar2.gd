extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var maxSpeed: float = 400.0
@export var jumpHeight: float = -610.0
@export var charAccel: float = 30.0
@export var charDeccel: float = 50.0
@export var fallSpeedMultiplier: float = 1.5

@export var playerCharSprite: AnimatedSprite2D

var hasDoubleJumped: bool = false
var groundSlamming: bool = false
var isFacingRight: bool = true
var jumpHeightMultiplier: float = 1.0

func _ready():
	global_position.x = GameManager.playerSpawnX
	global_position.y = GameManager.playerSpawnY
	velocity = Vector2(GameManager.playerVelocityX, GameManager.playerVelocityY)
	playerCharSprite.play("idleAnim")

func _process(delta):
	if abs(velocity.x) > 0.1 and is_on_floor():
		playerCharSprite.play("walkAnim")
	else:
		playerCharSprite.play("idleAnim")

func _physics_process(delta):
	
	
	
	# Handles jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		hasDoubleJumped = false
		velocity.y += jumpHeight * jumpHeightMultiplier
	
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.5
	
	# Handles double jumping
	if GameManager.activeUpgrades[2]:
		if Input.is_action_just_pressed("jump") and !is_on_floor() and !is_on_wall() and velocity.y > 5.0 and !hasDoubleJumped and GameManager.activeUpgrades[0]:
			hasDoubleJumped = true
			velocity.y = jumpHeight * 0.75
	else:
		if Input.is_action_just_pressed("jump") and !is_on_floor() and velocity.y > 5.0 and !hasDoubleJumped and GameManager.activeUpgrades[0]:
			hasDoubleJumped = true
			velocity.y = jumpHeight * 0.75
	
	# Handles wall jumping
	if is_on_wall_only() and Input.is_action_just_pressed("jump") and GameManager.activeUpgrades[2]:
		velocity.y = jumpHeight * 1.25
		if isFacingRight:
			velocity.x = jumpHeight * 0.8
		else:
			velocity.x = jumpHeight * -1.0
	
	move_and_slide()
