
export default class Validator

	constructor:(@joi)->
		@rules 		= {}
		@extensions = {}

	rule:(rules)->

		if rules instanceof Function
			rules = rules.call null, @joi

		Object.assign @rules, rules
		return @

	extend:(extensions)->
		extensions = Array extensions

		extensionClassMethods = [
			'extend'
			'handle'
			'run'
		]

		for extension in extensions

			for name in extensionClassMethods
				if method = extension[name]
					extension = method.bind extension
					break

			if extension instanceof Function
				@joi = @joi.extend extension
				break

			throw new Error "Invalid validation extension type."

		return @

	toSchema:(fields)->
		schema = {}
		for field in fields
			if !@rules[field]
				throw new Error "Validation rule doesn't exist for field: #{field}"

			schema[field] = @rules[field]

		return @joi.object().keys schema

	validate:(data, schema)->
		if Array.isArray schema
			schema = @toSchema schema

		return @joi.validate data, schema
