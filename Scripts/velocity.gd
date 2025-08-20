extends VBoxContainer

var vel_par1 = Global.velocity_params[0]
var vel_par2 = Global.velocity_params[1]

func _ready():
	_match_par()

func _match_par():
	var vel_dist := Global.velocity_distribution
	
	match vel_dist:
		0: # Normal Distribution
			vel_par1 = 0.0
			vel_par2 = 1.0
		1: # Uniform Distribution
			vel_par1 = -1.0
			vel_par2 = 1.0
		_:
			print('Error Determining Latitude Distribution')
			
	$HBoxContainer3/VBoxContainer/VelocityPar1.text = str(vel_par1)
	$HBoxContainer3/VBoxContainer2/VelocityPar2.text = str(vel_par2)


func _on_velocity_distribution_item_selected(index: int) -> void:
	match index:
		0:
			$HBoxContainer3/VBoxContainer/Par1.text = "μ"
			$HBoxContainer3/VBoxContainer2/Par2.text = "σ"
			Global.velocity_distribution = Global.Distribution.NORMAL
		1:
			$HBoxContainer3/VBoxContainer/Par1.text = 'Min'
			$HBoxContainer3/VBoxContainer2/Par2.text = 'Max'
			Global.velocity_distribution = Global.Distribution.UNIFORM
		_:
			pass
	_match_par()


func _on_velocity_par_1_text_submitted(new_text: String) -> void:
	var p = float(new_text)
	$HBoxContainer3/VBoxContainer/VelocityPar1.text = str(p)
	Global.velocity_params[0] = p


func _on_velocity_par_2_text_submitted(new_text: String) -> void:
	var p = float(new_text)
	$HBoxContainer3/VBoxContainer2/VelocityPar2.text = str(p)
	Global.velocity_params[1] = p
