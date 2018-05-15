
export default class Scheduler
	@tasks = []

	addTask: (expression, task) ->
		@tasks.push {
			expression: expression
			task: task
		}

	getTasks: () ->
		return @tasks
