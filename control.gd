extends Control

const SERVOR_ID = "127.0.0.1"
const SERVOR_PORT = 9999

var Name := "Anonymous"
var multiplayer_scene = preload("res://node.tscn")
var player_spawn_manager
func _on_host_pressed() -> void:
	print("you are host")
	
	player_spawn_manager = get_tree().get_current_scene().get_node("Node")
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVOR_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(add_player_to_game)
	add_player_to_game(1)
func _on_join_pressed() -> void:
	print("you join as player 2")
	
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVOR_ID,SERVOR_PORT)
	
	multiplayer.multiplayer_peer = client_peer
	


func add_player_to_game(id : int):
	print("Player %s a rejoint la partie!" % id)
	
	var player_to_add = multiplayer_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	player_spawn_manager.add_child(player_to_add)

	
func del_player(id : int):
	print("Player %s a quitté la partie ;c" % id)
	if not player_spawn_manager.has_node(str(id)):
		return
	player_spawn_manager.get_node(str(id)).queue_free()
	
func remove_player():
	print("Single Player Removed")
	var player_to_remove = get_tree().get_current_scene().get_node("Node")
	player_to_remove.queue_free()

@rpc("call_local","any_peer")
func subit_text(text):
	var idk = Label.new()
	%VBoxContainer.add_child(idk)
	var Amogus := "Host" if multiplayer.get_remote_sender_id() == 1 else "Guest"
	idk.text =("%s : %s" %[Amogus,text])
	
	
func _on_label_2_text_submitted(new_text: String) -> void:
	subit_text.bind(new_text).rpc()
	$Message.text = ""
func _on_name_text_submitted(new_text: String) -> void:
	Name = new_text
