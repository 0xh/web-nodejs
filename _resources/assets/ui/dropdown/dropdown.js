var $ = require('jquery');
var Drop = require('tether-drop');

function createDropdown(element) {
	var $self, $target, position, content, openOn;

	$self    = $(element);
	$target  = $self.data('target')   || $self.find('.drop-target');
	position = $self.data('position') || 'bottom left';
	openOn   = $self.data('open-on')  || 'click';
	content  = $self.data('content')  || $self.find('.drop-content').html();

	new Drop({
		target: $target[0],
		position: position,
		constrainToWindow: true,
		constrainToScrollParent: false,
		openOn: openOn,
		content: content
	});
}


$('.dropdown').each(function() {
	createDropdown(this);
});

$('.datagrid').bind('DOMSubtreeModified', function(event) {
	$('.datagrid .dropdown').each(function() {
		createDropdown(this);
	});
});
