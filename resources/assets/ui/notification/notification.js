var $ = require('jquery');
var $window = $(window);

$('.notification--hide-and-slide').each(function() {
	var close, closeHandler, element, keydownHandler;

	$element = $(this);

	setTimeout(function() {
		$element.addClass('notification--shown');
	}, 1);

	closeHandler = function() {
		$element.removeClass('notification--shown');
		$window.off('keydown', keydownHandler);
	};

	keydownHandler = function(e) {
		if (e.which === 27) {
			closeHandler();
		}
	};

	$close = $element.find('.notification__close');
	$close.on('click', closeHandler);

	$window.on('keydown', keydownHandler);
});
