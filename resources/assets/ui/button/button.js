var $ = require('jquery');

$('button[enabled], .btn[enabled]').on('click', function(event) {
	var $this = $(this);

	$this.removeAttr('enabled');
	$this.attr('loading', true);
	$this.attr('disabled', true);
});
