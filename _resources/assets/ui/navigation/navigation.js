
var $ = require('jquery');

$('.main-nav__toggle').on('click', function(event) {
	$('.main-nav').toggleClass('main-nav--open');
});
