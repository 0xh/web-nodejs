
env = process.env

export default
	env: 	env.ENV or 'local'
	name: 	env.NAME or 'blacklist-service'
	debug: 	env.DEBUG or false

	secret: [
		env.SECRET_1
		env.SECRET_2
		env.SECRET_3
	]

	services: [
		__dirname + '/../src/service-provider/core'
		__dirname + '/../src/service-provider/middleware'
		__dirname + '/../src/service-provider/action'
		__dirname + '/../src/service-provider/resource'
		__dirname + '/../src/service-provider/rules'
	]
