
import requireDir from 'require-dir'

# env helper function
env = (name, defaultValue)->
	value = process.env[name]
	if typeof value is 'undefined'
		return defaultValue

	if value is 'true' or value is 'TRUE'
		return true

	if value is 'false' or value is 'FALSE'
		return false

	if !isNaN value
		return Number value

	if value is 'null' or value is 'NULL'
		return null

	return value


export load = ->

	# Before loading the config files we define a global
	# env helper function. And we save the old env func.
	oldFunc = global.env
	global.env = env

	# Load the config file
	config = requireDir "../config/", { recurse: true }
	Object.freeze config

	# Restore the old env func
	global.env = oldFunc

	return config
