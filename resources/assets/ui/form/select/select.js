var $ = require('jquery');

$('.select').each(function() {
	var $this  = $(this);
	var $input = $('.select__input', this);
	var $placeholder = $('.select__placeholder', this);

	$input.on('change changed', function() {
		var value = $(this).find(':selected').val();
		var text  = $(this).find(':selected').text().trim();

		if (text) {
			$placeholder.text(text);
		}

		if (value !== '') {
	    	$this.addClass('select--selected');
		} else {
			$this.removeClass('select--selected');
		}
	});
});
