
export default class Middleware

	middleware: ->
		return (context, next) =>
			return @handle context, next
