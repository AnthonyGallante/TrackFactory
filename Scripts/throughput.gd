extends HBoxContainer

func _ready():
	var x := Global.throughput
	$Throughput.text = str(x)
	$ThroughputSlider.value = float(x)


func _on_throughput_value_changed(value: float) -> void:
	var x := float(value)
	$Throughput.text = str(x)
	Global.throughput = float(x)


func _on_throughput_text_submitted(new_text: String) -> void:
	var x := float(new_text)
	$ThroughputSlider.value = x
	Global.throughput = float(x)
	
