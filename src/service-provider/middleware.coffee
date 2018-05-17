
import ServiceProvider 		from '../core/service-provider'
import ErrorHandler 		from '../middleware/error-handler'
import ResponseTime 		from '../middleware/response-time'

export default class Middleware extends ServiceProvider

	boot: ->
		@middleware 'middleware.error-handler'
		@middleware 'middleware.response-time'

		@when 'production', ->
			@middleware 'middleware.force-https'

	register: ->

		@singleton 'middleware.error-handler', ->
			return new ErrorHandler @logger

		@singleton 'middleware.response-time', ->
			return new ResponseTime
