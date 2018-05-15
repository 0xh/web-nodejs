
import ServiceProvider 	from '../core/service-provider'
import Joi 				from 'joi'

export default class Rules extends ServiceProvider

	boot: ->

		@rules {
			# Joi.number().min(0).integer().positive().default(0)
		}
