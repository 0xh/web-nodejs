var $ = require('jquery');

$('body').on('keydown', '.numeric', function(event) {
	// console.log(event.keyCode);
	return  (event.keyCode >= 48 && event.keyCode <= 57) ||  // 0-9
			(event.keyCode >= 96 && event.keyCode <= 105) || // 0-9 (numpad)
	  		event.keyCode === 8 ||   // Backspace
	  		event.keyCode === 9 ||   // Tab
	  		event.keyCode === 17 ||  // Control
	  		event.keyCode === 37 ||  // Left
	  		event.keyCode === 39 ||  // Right
			// event.keyCode === 110 || // Dot (numpad)
			event.keyCode === 190;   // Dot
});
