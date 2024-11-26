extends CanvasLayer

func change_scene_to_file(target: String, type: String = 'dissolve') -> void:
	if type == 'dissolve':
		transition_dissolve(target)
	#else:
		#transition_clouds(target)

func transition_dissolve(target: String) -> void:
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards('dissolve')

#func transition_clouds(target: String) -> void:
#	$AnimationPlayer.play('clouds_in')
#	yield($AnimationPlayer,'animation_finished')
#	get_tree().change_scene(target)
#	$AnimationPlayer.play('clouds_out')
