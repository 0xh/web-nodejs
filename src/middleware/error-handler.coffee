
import Middleware from '../core/middleware'

export default class ErrorHandler extends Middleware
	constructor: (@logger) ->
		super()

	handle: (ctx, next) ->
		try
			await next()
		catch error
			@_handleError ctx, error

	_handleError: (ctx, error) ->
		status  = error.status || 500
		message = error.originalError || error.message

		if error.name == "ValidationError"
			status  = 400
			message = error.details[0].message

		else if !(error instanceof ViewableError)
			@logger.error error
			message = 'Something went wrong'

		ctx.body =
			error:
				message: String message
