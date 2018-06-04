
import Container 	from '../src/core/container'
import requireDir	from 'require-dir'
import dotenv	 	from 'dotenv'
import winston		from 'winston'

# dirty env helper on the global scope.
global.env = (name, defaultValue)->
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

export default (kernels = []) ->

	container = new Container

	# ----------------------------------------
	# Fase 1: Load the environment variables

	dotenv.load()


	# ----------------------------------------
	# Fase 2: Load the config file

	config = requireDir "../config/", { recurse: true }
	Object.freeze config

	container.instance 'config', config


	# ----------------------------------------
	# Fase 3: Create the logger instance

	drivers = config.logging.drivers
	logger = new winston.Logger {
		level: config.logging.level
	}

	if drivers.includes 'sentry'
		Sentry = require 'winston-raven-sentry'
		logger.add Sentry, config.logging.sentry

	if drivers.includes 'console'
		logger.add winston.transports.Console

	container.instance 'logger', logger


	# ----------------------------------------
	# Fase 4: construct the service providers

	providers = []

	try
		for path in config.app.services
			ServiceProvider = require path
			serviceProvider = new ServiceProvider container
			providers.push serviceProvider

		# ----------------------------------------
		# Fase 5: register the services

		for serviceProvider in providers
			await serviceProvider.register()


		# ----------------------------------------
		# Fase 6: boot the services up

		for serviceProvider in providers
			await serviceProvider.boot()


		# ----------------------------------------
		# Fase 7: start the kernels

		for kernel in kernels
			instance = container.make kernel
			await instance.run()

	catch error
		logger.error error

		# This means every uncaught error will exit the application
		process.exit()
