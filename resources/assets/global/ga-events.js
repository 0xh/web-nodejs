var $ = require('jquery');

$('.btn[data-ga]').each(function() {
	var $element = $(this);

	$element.on('click', function() {
		ga('send', {
			hitType: 'event',
			eventCategory: $element.data('ga'),
			eventAction: $element.data('ga-action'),
			eventLabel: $element.data('ga-label'),
			eventValue: 1,
		});
	});
});
