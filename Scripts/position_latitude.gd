extends VBoxContainer

var lat_par1 = Global.latitude_params[0]
var lat_par2 = Global.latitude_params[1]

func _ready():
	_match_par()

func _match_par():
	var lat_dist := Global.latitude_distribution
	
	match lat_dist:
		0: # Normal Distribution
			lat_par1 = 0.0
			lat_par2 = 1.0
		1: # Uniform Distribution
			lat_par1 = -1.0
			lat_par2 = 1.0
		_:
			print('Error Determining Latitude Distribution')
			
	$HBoxContainer3/VBoxContainer/LatPar1.text = str(lat_par1)
	$HBoxContainer3/VBoxContainer2/LatPar2.text = str(lat_par2)


func _on_latitude_distribution_item_selected(index: int) -> void:
	match index:
		0:
			$HBoxContainer3/VBoxContainer/Par1.text = "μ"
			$HBoxContainer3/VBoxContainer2/Par2.text = "σ"
			Global.latitude_distribution = Global.Distribution.NORMAL
		1:
			$HBoxContainer3/VBoxContainer/Par1.text = 'Min'
			$HBoxContainer3/VBoxContainer2/Par2.text = 'Max'
			Global.latitude_distribution = Global.Distribution.UNIFORM
		_:
			pass
			
	_match_par()


func _on_lat_par_1_text_submitted(new_text: String) -> void:
	var p = float(new_text)
	$HBoxContainer3/VBoxContainer/LatPar1.text = str(p)
	Global.latitude_params[0] = p


func _on_lat_par_2_text_submitted(new_text: String) -> void:
	var p = float(new_text)
	$HBoxContainer3/VBoxContainer2/LatPar2.text = str(p)
	Global.latitude_params[1] = p
