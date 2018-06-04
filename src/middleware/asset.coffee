
import zlib 			from 'zlib'
import crypto 			from 'crypto'
import Middleware 		from '../core/middleware'
import ViewableError 	from '../error/viewable-error'

export default class Asset extends Middleware

	constructor: (@resource, @debug = true) ->
		super()

	compile:->
		src = await fs.readFile @resource, 'utf8'
		return src.toString 'utf8'

	setup:->
		# fill the cache when debug mode is turned off
		if !@debug
			@cache = await @build()

	handle: (ctx, next) ->

		# serve from cache
		if @cache
			ctx.response.set 'Cache-Control', 'max-age=2592000, public'
			@response ctx, @cache
			return

		# build asset from source
		file = await @build()
		@response ctx, file


	response:(ctx, file)->

		ctx.status 			= 200
		ctx.response.etag 	= file.md5
		ctx.type 			= @mime

		# don't send anything for repeat clients
		if ctx.fresh
			ctx.status = 304
			return

		# serving gzipped asset
		if file.zip and @shouldGzip ctx
			ctx.remove 	'Content-Length'
			ctx.set 	'Content-Encoding', 'gzip'
			ctx.body = file.zip
			return

		ctx.body = file.src
		return

	build:->

		src = await @compile()
		md5 = @md5 src

		return {
			src
			md5
			uri: @uri md5
			zip: await @gzip src
		}

	shouldGzip:(ctx)->
		encodings = ctx.acceptsEncodings()
		return ~encodings.indexOf 'gzip'

	uri: (md5)->
		uri = Buffer.from md5, 'base64'
		return uri.toString 'base32'

	md5: (src)->
		return crypto
			.createHash 'md5'
			.update src
			.digest 'base64'

	gzip: (src)->
		buf = Buffer.from src, 'utf8'
		return new Promise (resolve, reject)=>
			zlib.gzip buf, (error, result)->
				if error
					reject error
				else
					resolve result
