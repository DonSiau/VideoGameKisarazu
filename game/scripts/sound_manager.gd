extends Node

var sounds = {
    "death": "res://sfx/damage6.wav",
    "menuAccept": "res://sfx/MenuAccept.wav"
}

func play_sound(sound_name: String, dB: int=0, bus_name: String="SFX"):
    if sounds.has(sound_name):
        var player = AudioStreamPlayer.new()
        player.volume_db+=dB
        player.bus=bus_name
        player.stream = load(sounds[sound_name])
        player.finished.connect(player.queue_free)
        add_child(player)
        player.play()
