extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_logger();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _init_logger():

	Logger.set_logger_level(Logger.LOG_LEVEL_DEBUG)
	Logger.set_logger_format(Logger.LOG_FORMAT_MORE)
	var file_appender:Appender = Logger.add_appender(FileAppender.new("res://debug.log"))
	file_appender.logger_format=Logger.LOG_FORMAT_FULL
	file_appender.logger_level = Logger.LOG_LEVEL_TRACE
