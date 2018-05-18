var $ = require('jquery');

$('body').on('click', '.confirm', function(event) {
	event.preventDefault();

	var redirect = $(this).attr('href');
	var $popup   = $('.confirm-popup');
	var content  = $(this).data('confirm-text');

	if (content) {
		$popup.find('.confirm-popup-text').text(content);
	}

	$popup.data('redirect-url', redirect);
	$popup.addClass('is-visible');
});

/// Confirm the action
$('.confirm-popup').on('click', '.confirm-popup-confirm', function(event) {
	event.preventDefault();

	redirect = $('.confirm-popup').data('redirect-url');
	window.location = redirect;
});

// Cancel the action
$('.confirm-popup').on('click', '.confirm-popup-cancel', function(event) {
	event.preventDefault();
	$('.confirm-popup').removeClass('is-visible');
});

// close popup
$('.confirm-popup').on('click', function(event){
	if ($(event.target).is('.confirm-popup-close') || $(event.target).is('.confirm-popup')) {
		event.preventDefault();
		$(this).removeClass('is-visible');
	}
});

// Close popup when clicking the esc keyboard button
$(document).keyup(function(event){
	if(event.which=='27'){
		$('.confirm-popup').removeClass('is-visible');
    }
});
