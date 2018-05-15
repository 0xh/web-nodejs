
import Action from '../core/action'

export default class Health extends Action

	handle: (ctx) ->

		ctx.body   = 'OK'
		ctx.status = 200
