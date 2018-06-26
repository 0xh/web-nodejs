
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

		# ----------------------------------------------------
		# 1. handle viewable validation errors

		if error.name is "ValidationError"
			status  = 400
			message = error.details[0].message

		# ----------------------------------------------------
		# 2. handle custom viewable errors

		else if error instanceof ViewableError
			status 	= error.status or 500
			message = error.originalError or error.message

		# ----------------------------------------------------
		# 3. handle server errors

		else
			@logger.error error

			status 	= 500
			message = 'Oeps! Something went wrong.'

		# ----------------------------------------------------
		# structure the error response

		ctx.status = status
		ctx.body =
			error:
				message: String message
