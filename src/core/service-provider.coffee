
import Middleware from './middleware'

export default class ServiceProvider

	constructor:(@container)->

		# ------------------------------------------
		# define alias helper

		# functions
		@singleton 	= @container.singleton.bind @container
		@instance 	= @container.instance.bind @container
		@make 		= @container.make.bind @container

		# properties
		@debug 		= @container.config.app.debug
		@env 		= @container.config.app.env


	register:->
	boot:->


	resolveMiddleware:(instance, ...params)->
		if typeof instance is 'string'
			instance = @container.make instance

		if instance instanceof Function
			return instance

		if instance instanceof Middleware
			return instance.middleware.apply instance, params

		throw new Error "Middleware must be a function or [Middleware] object, not #{typeof instance}"

	# ------------------------------------------
	# Env helpers

	when:(environment, callback = null)->

		if environment is @container.config.app.env
			if callback
				await callback.call @

			return true

		return false

	# ------------------------------------------
	# Middleware helpers

	middleware:(middleware)->
		middleware = @resolveMiddleware middleware
		koa = @container.make 'koa'

		koa.use middleware

	route:(method, path, action)->

		router 		= @container.make 'router'
		validator 	= @container.make 'validator'

		middleware 	= @resolveMiddleware action, validator

		router[method].call router, path, middleware

	# ------------------------------------------
	# Route helpers

	get:(path, action)->
		return @route 'get', path, action

	post:(path, action)->
		return @route 'post', path, action

	put:(path, action)->
		return @route 'put', path, action

	delete:(path, action)->
		return @route 'delete', path, action

	# ------------------------------------------
	# Validation helpers

	# rules:(rules)->
	# 	set = @container.make 'rule-set'
	# 	Object.assign set, rules

	# ------------------------------------------
	# Database helpers

	migrate: ->
		database = @container.make 'database'
		await database.migrate.latest()

	seed: ->
		database = @container.make 'database'
		await knex.seed.run()

	# ------------------------------------------
	# Cronjob helpers

	schedule: (expression, task) ->
		cronjob = @container.make 'cronjob'
		cronjob.addTask expression, task
