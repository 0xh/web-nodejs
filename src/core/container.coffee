
export default class Container

	constructor: ->
		@instances 				= {}
		@singletonFactories 	= {}
		@factories 				= {}

	instance: (name, instance) ->
		@instances[name] = instance
		return @

	singleton: (name, factory) ->
		@singletonFactories[name] = factory
		return @

	bind: (name, factory) ->
		@factories[name] = factory
		return @

	# construct an object instance.
	make: (name, ...args) ->
		# check if the instance has already been
		# created as a singleton
		if (result = @instances[name])
			return result

		# check if the instance is a singleton
		# and construct it.
		if (factory = @singletonFactories[name])
			object = factory.call @
			@instances[name] = object
			return object

		# check if factory function exists.
		if (factory = @factories[name])
			return factory.apply @, args

		throw new Error 'Instance not found: ' + name
