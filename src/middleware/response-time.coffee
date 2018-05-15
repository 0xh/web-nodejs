
import Middleware from '../core/middleware'

export default class ResponseTime extends Middleware
	handle: (ctx, next) ->
		start = Date.now()
		await next()
		ms = Date.now() - start

		ctx.set 'X-Response-Time', "#{ms}ms"
		console.log "#{ctx.method} #{ctx.url} - #{ms}ms"
