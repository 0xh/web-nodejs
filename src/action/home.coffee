
import Action from '../core/action'

export default class Home extends Action

	handle: (ctx) ->

		data = {
			meta: {
				title: 'Homepage'
				description: 'Homepage'
			}
		}

		await ctx.render 'pages/home', data
