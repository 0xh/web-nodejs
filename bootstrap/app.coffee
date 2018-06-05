
import Container 		from '../src/core/container'
import ConfigLoader 	from '../src/core/config-loader'
import dotenv	 		from 'dotenv'
import winston			from 'winston'

export default (kernels = []) ->

	container = new Container

	# ----------------------------------------
	# Fase 1: Load the environment variables
	# from a .env file

	dotenv.load()


	# ----------------------------------------
	# Fase 2: Load the config file

	config = ConfigLoader.load()
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
