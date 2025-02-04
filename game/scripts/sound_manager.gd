extends Node
var menuIsPlaying = false
var menu_player : AudioStreamPlayer

var sounds = {
    "death": "res://sfx/damage6.wav",
    "menuAccept": "res://sfx/MenuAccept.wav",
    "menuMusic": "res://assets/music/MenuMusic.ogg"
}

func play_sound(sound_name: String, dB: int=0, bus_name: String="SFX"):
    var player = AudioStreamPlayer.new()
    if sounds.has(sound_name):
        player.volume_db += dB
        player.bus = bus_name
        player.stream = load(sounds[sound_name])
        player.finished.connect(player.queue_free)
        add_child(player)
        if sound_name == 'menuMusic':
            if !menuIsPlaying:
                if menu_player != null:
                    menu_player.queue_free()
                menu_player = player
                player.play()
                menuIsPlaying = true
        else:
            player.play()
func stop_menu_music():
    if menu_player != null:
        menu_player.queue_free()
        menuIsPlaying = false
