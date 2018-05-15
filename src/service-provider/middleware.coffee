
import ServiceProvider 		from '../core/service-provider'
import ErrorHandler 		from '../middleware/error-handler'
import ResponseTime 		from '../middleware/response-time'

export default class Middleware extends ServiceProvider

	boot: ->

		@middleware 'middleware.error-handler'
		@middleware 'middleware.response-time'


	register: ->

		@singleton 'middleware.error-handler', ->
			return new ErrorHandler @make 'logger'

		@singleton 'middleware.response-time', ->
			return new ResponseTime
