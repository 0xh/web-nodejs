
import Middleware from './middleware'

export default class Action extends Middleware

	middleware:(@validator)->

		if @fields and @fields.length
			schema = @validator.toSchema @fields

		# schema1 = @validator.toSchema @query
		# schema2 = @validator.toSchema @body
		# schema3 = @validator.toSchema @params

		return (context, next)=>

			data = Object.assign(
				{},
				context.request.query,
				context.request.body,
				context.params
			)

			if schema
				data = await @validator.validate data, schema

			# query 	= await @validator.validate context.query, 	schema1
			# body 		= await @validator.validate context.body, 	schema2
			# params 	= await @validator.validate context.params, schema3

			return @handle context, data
