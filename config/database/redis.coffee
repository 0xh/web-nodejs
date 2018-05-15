
env = process.env

export default
	database:
		host: 	  env.REDIS_DB_HOST or '127.0.0.1'
		port: 	  parseInt(env.REDIS_DB_PORT) or 6379
		database: parseInt(env.REDIS_DB_DATABASE) or 0

	locking: [
		{
			host: env.REDIS_DB_LOCK1 or '127.0.0.1'
			port: 6379
			database: 2
		}
		{
			host: env.REDIS_DB_LOCK2 or '127.0.0.1'
			port: 6379
			database: 3
		}
		{
			host: env.REDIS_DB_LOCK3 or '127.0.0.1'
			port: 6379
			database: 4
		}
	]
