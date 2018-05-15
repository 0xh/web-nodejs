
import Router 			from 'koa-router'
import Koa 				from 'koa'
import Pug 				from 'koa-pug'
import ServiceProvider 	from '../core/service-provider'
import HttpKernel 		from '../kernel/http'
import ManifestHelper	from '../helper/manifest-helper'

path = require('path')

export default class Core extends ServiceProvider

	register: ->

		@singleton 'rule-set', ->
			return {}

		@singleton 'router', ->
			return new Router

		@singleton 'koa', ->
			return new Koa

		@singleton 'pug', ->
			config = @make 'config'
			manifestHelper = new ManifestHelper './public/build/rev-manifest.json'

			return new Pug {
				viewPath: 	'./resources/views/'
				debug: 		config.app.debug
				pretty: 	config.app.debug
				helperPath: [
					{ rev: manifestHelper.helper() }
				]
				locals: {
					test: 'test'
				}
			}

		@singleton 'logger', ->
			config = @make 'config'

			logger = winston.createLogger {
				level:	'info'
				format:	winston.format.json()
				transports: [
					new winston.transports.Console
					new winston.transports.File { filename: 'combined.log' }
					new Sentry options
				]
			}

			return logger

		@singleton 'kernel.http', ->
			router = @make 'router'
			config = @make 'config'

			return new HttpKernel router, config.http.port
