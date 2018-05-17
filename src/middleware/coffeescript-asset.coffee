
import path 		from 'path'
import browserify 	from 'browserify'
import coffeeify 	from 'coffeeify'
import uglifyify 	from 'uglifyify'
import babelify 	from 'babelify'
import Asset 		from './asset'

export default class CoffeescriptAsset extends Asset

	mime: 'application/javascript'

	compile:->

		return new Promise (resolve, reject)=>
			options = {
				debug: @debug
				extensions: ['.coffee']
				# exposeAll: true
				# noparse: true
			}
			b = browserify options
			b.on 'error', reject
			b.add @resource
			#b.transform pugify.pug()
			b.transform coffeeify
			b.transform babelify, {
				presets: ["es2015"]
				extensions: ['.coffee']
			}

			if !@debug
				b.transform uglifyify, { global: true }

			b.bundle (error, result)->
				if error
					return reject error

				resolve result
