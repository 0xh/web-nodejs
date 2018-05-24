
export default

	connection:
		host: 	  env 'REDIS_DB_HOST', '127.0.0.1'
		port: 	  env 'REDIS_DB_PORT', 6379
		database: env 'REDIS_DB_DATABASE', 0

	locking: [
		{
			host: env 'REDIS_DB_LOCK1', '127.0.0.1'
			port: 6379
			database: 1
		}
		{
			host: env 'REDIS_DB_LOCK2', '127.0.0.1'
			port: 6379
			database: 1
		}
		{
			host: env 'REDIS_DB_LOCK3', '127.0.0.1'
			port: 6379
			database: 1
		}
	]
