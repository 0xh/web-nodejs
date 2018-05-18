const $ = require('jquery');
const $el = $('.topbar');

$(window).scroll(function() {
	toggleTopbar();
});

toggleTopbar(0);

function toggleTopbar(fadeInDuration)
{
	const y = $(window).scrollTop();

	if (y > 60) {
		$el.fadeIn(fadeInDuration || 250);
	} else {
		$el.fadeOut(75);
	}
}
