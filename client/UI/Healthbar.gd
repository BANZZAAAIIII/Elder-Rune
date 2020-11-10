extends TextureProgress

onready var tween = $Tween 

var animated_health = 0

# Setup healthbar
func _ready():
	var enemy_health = get_parent().health # Get health from parent
	self.max_value = enemy_health # Set max value of the healthbar
	update_health(enemy_health)
	
	
	# Setup signals
	get_parent().connect("health_changed", self, "_on_Enemy_health_changed") # All enemies must have signal health_changed
	
func _process(delta):
	var round_value = round(animated_health)
	self.value = round_value

# updates healthbar
func update_health(new_value):
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.6, tween.TRANS_LINEAR, tween.EASE_IN)
	if not $Tween.is_active():
		$Tween.start()

# Triggers when enemy takes damage
func _on_Enemy_health_changed(health):
	update_health(health)
