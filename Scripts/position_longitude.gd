extends VBoxContainer

var long_par1 = Global.longitude_params[0]
var long_par2 = Global.longitude_params[1]

func _ready():
	_match_par()

func _match_par():
	var long_dist := Global.longitude_distribution
	
	match long_dist:
		0: # Normal Distribution
			long_par1 = 0.0
			long_par2 = 1.0
		1: # Uniform Distribution
			long_par1 = -1.0
			long_par2 = 1.0
		_:
			print('Error Determining Latitude Distribution')
			
	$HBoxContainer3/VBoxContainer/LonPar1.text = str(long_par1)
	$HBoxContainer3/VBoxContainer2/LonPar2.text = str(long_par2)


func _on_longitude_distribution_item_selected(index: int) -> void:
	match index:
		0:
			$HBoxContainer3/VBoxContainer/Par1.text = "μ"
			$HBoxContainer3/VBoxContainer2/Par2.text = "σ"
			Global.longitude_distribution = Global.Distribution.NORMAL
		1:
			$HBoxContainer3/VBoxContainer/Par1.text = 'Min'
			$HBoxContainer3/VBoxContainer2/Par2.text = 'Max'
			Global.longitude_distribution = Global.Distribution.UNIFORM
		_:
			pass
	_match_par()


func _on_lon_par_1_text_submitted(new_text: String) -> void:
	var p = float(new_text)
	$HBoxContainer3/VBoxContainer/LonPar1.text = str(p)
	Global.longitude_params[0] = p


func _on_lon_par_2_text_submitted(new_text: String) -> void:
	var p = float(new_text)
	$HBoxContainer3/VBoxContainer2/LonPar2.text = str(p)
	Global.longitude_params[1] = p
