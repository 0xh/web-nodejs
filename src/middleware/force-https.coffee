
import Middleware from '../core/middleware'

export default class ForceHttps extends Middleware
	constructor: (@env) ->

	handle: (ctx, next) =>
		if !ctx.secure && @env == 'production'
			ctx.status = 403
			ctx.body   = 'HTTPS required'
			ctx.throw ctx.status, ctx.body

		next()
