
export default
	env: 	env 'ENV', 'local'
	name: 	env 'NAME', 'blacklist-service'
	debug: 	env 'DEBUG', false

	secret: [
		env 'SECRET_1'
		env 'SECRET_2'
		env 'SECRET_3'
	]

	services: [
		__dirname + '/../src/service-provider/core'
		__dirname + '/../src/service-provider/middleware'
		__dirname + '/../src/service-provider/action'
		__dirname + '/../src/service-provider/resource'
		__dirname + '/../src/service-provider/rules'
	]
