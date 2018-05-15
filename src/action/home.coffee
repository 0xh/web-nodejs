
import Action from '../core/action'

export default class Home extends Action

	constructor: (@pug) ->
		super()

	handle: (ctx) ->

		data = {
			meta: {
				title: 'Homepage'
				description: 'Homepage'
			}
		}

		ctx.body   = @pug.render 'pages/home', data
		ctx.status = 200
