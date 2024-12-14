extends AudioStreamPlayer2D

var current_music_track : AudioStream

func play_track(new_stream: AudioStream, volume):
	if stream != new_stream:
		stream = new_stream
	volume_db = volume
	play()

# The reason I change the pitch is to have it be less repetitve
func play_SFX(new_stream: AudioStream, volume, pitch):
	var sfx_player = AudioStreamPlayer2D.new()
	sfx_player.stream = new_stream
	sfx_player.volume_db = volume
	sfx_player.pitch_scale = pitch # Should always be within 0.9-1.1
	sfx_player.name = "SFX_Instance"
	add_child(sfx_player)
	sfx_player.play()
	
	await sfx_player.finished
	sfx_player.queue_free()
