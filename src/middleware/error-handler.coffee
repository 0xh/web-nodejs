
import Middleware 		from '../core/middleware'
import ViewableError 	from '../error/viewable-error'

export default class ErrorHandler extends Middleware

	constructor: (@logger) ->
		super()

	handle: (ctx, next) ->
		try
			await next()
		catch error
			@handleError ctx, error

	handleError: (ctx, error) ->
		status  = error.status or 500
		message = error.originalError or error.message

		if error.name == "ValidationError"
			status  = 400
			message = error.details[0].message

		else if !(error instanceof ViewableError)
			@logger.error error
			message = 'Something went wrong'

		ctx.body =
			error:
				message: String message
