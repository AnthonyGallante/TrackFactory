extends HBoxContainer

func _ready():
	var n := Global.n_simulations
	$NSimulations.text = str(int(n))
	$NSimulationsSlider.value = int(n)


func _on_sim_number_value_changed(value: float) -> void:
	var n := int(value)
	$NSimulations.text = str(n)
	Global.n_simulations = n


func _on_n_simulations_text_submitted(new_text: String) -> void:
	var n := int(new_text)
	$NSimulationsSlider.value = n
	Global.n_simulations = n
	
