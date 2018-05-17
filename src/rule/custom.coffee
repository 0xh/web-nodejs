
export default class CustomRule

	extend:(joi)->
		return {
			base: joi.string()
			name: 'string'
			language: {
				custom: 'must be something special'
			}
			rules: [
				{
					name: 'custom'
					validate: (params, value, state, options)->

						if value isnt 'special'
							return @createError 'string.custom', { v: value }, state, options

						return value
				}
			]
		}
