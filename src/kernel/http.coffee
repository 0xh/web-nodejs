
import Koa from 'koa'

export default class Http
	constructor: (@koa, @router, @httpPort) ->

	run: ->
		@koa.use @router.middleware()
		@koa.use @router.allowedMethods()

		@koa.listen @httpPort, =>
			console.log "HTTP server running at #{@httpPort}"
