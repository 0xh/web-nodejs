
import Container 	from '../src/core/container'
import requireDir	from 'require-dir'
import dotenv	 	from 'dotenv'
import winston		from 'winston'

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

	logger = new winston.Logger {
		level: config.logging.level
	}

	if config.logging.drivers.includes 'sentry'
		Sentry = require 'winston-raven-sentry'
		logger.add Sentry, config.logging.sentry

	if config.logging.drivers.includes 'console'
		logger.add winston.transports.Console

	container.instance 'logger', logger


	# ----------------------------------------
	# Fase 4: construct the service providers

	providers = []
	for path in config.app.services
		ServiceProvider = require path
		serviceProvider = new ServiceProvider container
		providers.push serviceProvider


	try
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
		# This means every uncaught error will exit the application
		logger.error error
		process.exit()
