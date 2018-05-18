
import CoffeescriptAsset 	from '../middleware/coffeescript-asset'
import StylusAsset 			from '../middleware/stylus-asset'
import ServiceProvider 		from '../core/service-provider'
import views 				from 'koa-views'
import serve 				from 'koa-static'

export default class Core extends ServiceProvider

	boot:->
		@bootStaticFiles()
		@bootViewRenderer()
		await @bootAssets()

	bootViewRenderer:->

		koa = @make 'koa'

		koa.use views './resources/views/', {
			extension: 'pug'
		}

	bootStaticFiles:->

		koa = @make 'koa'
		config = @make 'config'

		if config.app.debug
			app.use serve './public'

	bootAssets:->

		config = @make 'config'
		router = @make 'router'
		debug  = config.app.debug
		assets = new Object

		for route, resource of config.assets.scripts
			assets[route] = new CoffeescriptAsset resource, debug

		for route, resource of config.assets.styles
			assets[route] = new StylusAsset resource, debug

		promises = []
		for route, asset of assets
			handle = asset.handle.bind asset
			router.get route, handle

			promises.push asset.setup()

		await Promise.all promises
