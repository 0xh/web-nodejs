
module.exports =

	client: 'mysql'

	connection:
		host:   	env 'DB_HOST', 'localhost'
		port:		env 'DB_PORT', 3306
		database: 	env 'DB_DATABASE'
		user:  		env 'DB_USER'
		password: 	env 'DB_PASSWORD'

	migrations:
		tableName: '_migrations'
		directory: '../../database/migration'

	seeds:
		directory: '../../database/seed'
