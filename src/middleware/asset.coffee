
import zlib 			from 'zlib'
import crypto 			from 'crypto'
import Middleware 		from '../core/middleware'

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
			@respond ctx, @cache
			return

		# build asset from source
		file = await @build()
		@respond ctx, file


	respond:(ctx, file)->

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

		return {
			src
			md5: @md5 src
			zip: await @gzip src
		}

	shouldGzip:(ctx)->
		encodings = ctx.acceptsEncodings()
		return ~encodings.indexOf 'gzip'

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
