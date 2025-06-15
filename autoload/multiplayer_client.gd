extends Node

var BASE_API: String

var offline_mode := true

func _ready() -> void:
	BASE_API = Metadata.data.server
	test_connection()

func test_connection() -> void:
	var http_request := HTTPRequest.new()
	add_child(http_request)

	http_request.request_completed.connect(
		func (result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
			http_request.queue_free()
			
			if result != HTTPRequest.RESULT_SUCCESS:
				print("Unable to connect to server.")
				return
			
			print("Connected to server.")
			var json := JSON.new()
			json.parse(body.get_string_from_utf8())
			var response: Dictionary = json.get_data()
			
			if response["status"] == "available":
				offline_mode = false
	)
	
	print("Connecting to \"%s\"..." % BASE_API)
	http_request.request("%s/health-check" % BASE_API)
