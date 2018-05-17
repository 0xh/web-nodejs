
import Middleware from '../core/middleware'

export default class ForceHttps extends Middleware

	handle: (ctx, next) =>
		if !ctx.secure
			ctx.throw 403, 'HTTPS required'

		next()
