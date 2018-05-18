var $ = require('jquery');

$('button[type="submit"]').on('click', function(event) {
	$this = $(this);

	var target = $this.data('target-form');

	if (target) {
		$('form[name="'+target+'"]').submit();
	}
});
