
import Joi from 'joi'

export default class Action

	fields: []

	generateRules: (ruleSet) ->
		if !@rules
			rules = {}
			for field in @fields
				rules[field] = ruleSet[field]

			@rules = Joi.object().keys rules

		return @rules

	validate: (ctx, rules) ->
		if @fields.length
			input 	= Object.assign {}, ctx.request.query, ctx.request.body, ctx.params
			output 	= await Joi.validate input, rules

		return output

	middleware: (ruleSet) ->
		return (context, next) =>
			rules 	= @generateRules ruleSet
			data 	= await @validate context, rules
			return @handle context, data
