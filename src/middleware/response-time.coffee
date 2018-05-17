
import Middleware from '../core/middleware'

export default class ResponseTime extends Middleware

	handle: (ctx, next) ->

		startTime 		= Date.now()
		await next()
		endTime 		= Date.now()
		responseTime 	= endTime - startTime

		ctx.set 'X-Response-Time', "#{responseTime}ms"
