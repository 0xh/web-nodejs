
import CoffeescriptAsset 	from '../middleware/coffeescript-asset'
import StylusAsset 			from '../middleware/stylus-asset'
import ServiceProvider 		from '../core/service-provider'
import views 				from 'koa-views'
import serve 				from 'koa-static'

export default class Resource extends ServiceProvider

	register:->

		@singleton 'assets', ->
			config = @make 'config'
			debug  = config.app.debug
			assets = new Object

			for route, resource of config.assets.scripts
				assets[route] = new CoffeescriptAsset resource, debug

			for route, resource of config.assets.styles
				assets[route] = new StylusAsset resource, debug

			return assets

	boot:->

		@bootViewRenderer()
		await @bootAssets()

	bootViewRenderer:->

		koa = @make 'koa'

		koa.use views './resources/views/', {
			extension: 'pug'
		}

		koa.use (ctx, next)=>
			ctx.state =
				asset: (name)=>

					assets = @make 'assets'
					if (asset = assets[name]) and asset.cache
						return asset.cache.md5

					return name

			next()

	bootStaticFiles:->

		koa = @make 'koa'
		config = @make 'config'

		if config.app.debug
			app.use serve './public'

	bootAssets:->

		assets = @make 'assets'
		router = @make 'router'

		promises = []
		for route, asset of assets
			promises.push asset.setup @

		await Promise.all promises

		for route, asset of assets
			handle = asset.handle.bind asset
			router.get route, handle
			if asset.cache
				router.get '/' + asset.cache.md5, handle
				router.get '/+1+' + asset.cache.md5, handle
