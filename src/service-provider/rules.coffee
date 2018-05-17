
import ServiceProvider 	from '../core/service-provider'
import CustomRule 		from '../rule/custom'

export default class Rules extends ServiceProvider

	boot:->

		validator = @make 'validator'
		validator.extend @make 'rule.custom'
		validator.rule @rules

	rules:(joi)->
		return {
			custom: joi.string().custom()
		}

	register:->

		@singleton 'rule.custom', ->
			return new CustomRule
