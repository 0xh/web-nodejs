
export default
	level: 'info'
	drivers: [
		'console'
		# 'file'
		# 'sentry'
	]

	sentry:
		dsn: 	env 'SENTRY_DSN'
		level: 	'error'

		config:
			logger: 			'javascript'
			environment: 		env 'ENV'
			debug: 				env 'DEBUG'
			autoBreadcrumbs: 	true
			maxBreadcrumbs: 	150
