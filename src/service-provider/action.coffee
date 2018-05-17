
import ServiceProvider 	from '../core/service-provider'
import Health 			from '../action/health'
import Home 			from '../action/home'

export default class Action extends ServiceProvider

	boot: ->

		@get '/health', 'action.health'
		@get '/', 		'action.home'


	register: ->

		@singleton 'action.health', ->
			return new Health

		@singleton 'action.home', ->
			return new Home
