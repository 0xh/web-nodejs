var $ = require('jquery');

$(function()
{
	$.event.special.changed = {

		add:function(objHandle)
		{
			var object 	= $(this);
			var old 	= object.val();

			object.on('change blur keydown keyup', function()
			{
				setTimeout(function()
				{
					var value = object.val();

					if(old != value) {
						old = value;
						object.trigger('changed');
					}
				}, 10);
			});
		},

		remove:function(objHandle)
		{
			var obj = $(this);
			obj.off('change blur keydown keyup');
		}
	};

	$('.datagrid').each(function()
	{
		var sortTypes = {
			0: 'NONE',
			1: 'DESC',
			2: 'ASC'
		};

		var sortNumbers = {
			NONE: 0,
			DESC: 1,
			ASC: 2
		};

		var grid 			= $(this);
		var body 			= $('tbody', grid);
		var limitElement 	= $('.datagrid__limit', grid);
		var pagination 		= $('.datagrid__pagination', grid);


		var uri 	= grid.data('url');
		var id 		= grid.data('id');
		var offset 	= grid.data('offset');
		var found 	= grid.data('found');
		var total 	= grid.data('total');
		var shared 	= grid.data('shared');
		var limit 	= limitElement.val() || 10;
		var sort 	= {};
		var filters = [];
		var fetchId = 0;


		$('.datagrid__labels', grid).on('mousedown', '.datagrid__column--sortable', function()
		{
			return false;
		});

		$('.datagrid__labels', grid).on('click', '.datagrid__column--sortable', function(event)
		{
			event.preventDefault();

			var label 		= $(this);
			var attribute 	= label.data('id');
			var dir 		= sortNumbers[label.data('sort')] || 0;
			var others 		= $('.datagrid__labels .datagrid__column--sortable', grid);

			others.each(function()
			{
				var label = $(this);
				var attribute = label.data('id');

				label.data('sort', 		'NONE');
				label.attr('data-sort', 'NONE');

				sort[attribute] = 'NONE';
			});

			if(++dir > 2) dir = 1;

			dir = sortTypes[dir];

			label.data('sort', 		dir);
			label.attr('data-sort', dir);

			sort[attribute] = dir;

			fetch();
		});

		$('.datagrid__column--filter input', grid).on('changed', function()
		{
			var filter 	= $(this);
			var name 	= filter.attr('name');
			var value 	= filter.val();

			filters[name] = value;

			fetch();
		});

		pagination.on('click', '.datagrid__pagination-first button', function()
		{
			if(offset <= 0) return;

			offset = 0;
			fetch();
		});

		pagination.on('click', '.datagrid__pagination-previous button', function()
		{
			if(offset <= 0) return;

			offset--;
			fetch();
		});

		pagination.on('click', '.datagrid__pagination-page button', function()
		{
			var button = $(this);
			var newOffset = parseInt(button.data('offset'), 10);
			if(newOffset == offset) return;

			offset = newOffset;
			fetch();
		});

		pagination.on('click', '.datagrid__pagination-next button', function()
		{
			var max = Math.ceil(found / limit) - 1;
			if(offset >= max) return;

			offset++;
			fetch();
		});

		pagination.on('click', '.datagrid__pagination-last button', function()
		{
			var max = Math.ceil(found / limit) - 1;
			if(offset >= max) return;

			offset = max;
			fetch();
		});

		function fetch()
		{
			fetchId++;

			grid.addClass('datagrid__loading');

			var search = [],
				name,
				value;

			for(name in filters)
			{
				value = filters[name];
				if (value === '') continue;

				search.push([name, 'LIKE', '%' + value + '%']);
			}

			var data = {
				'search': 	search,
				'limit': 	limit,
				'offset': 	offset,
				'sort': 	sort,
				'shared':   shared,
			};

			$.get(uri, data, function(response)
			{
				body.html(response.list);
				found = parseInt(response.found, 10);

				var from 	= offset * limit + 1;
				var to 		= from + limit - 1;

				if(to > found) to = found;

				var length = Math.ceil(found / limit);

				var count 		= response.pagination.count;
				var pageStart 	= Math.ceil(offset - count / 2);

				if(pageStart > length - count) pageStart = length - count;
				if(pageStart < 0) pageStart = 0;

				var pageEnd 	= pageStart + count;

				if(pageEnd > length) pageEnd = length;
				if(pageEnd < 0) pageEnd = 0;

				$('.datagrid__pagination-from',  grid).text(from);
				$('.datagrid__pagination-to',    grid).text(to);
				$('.datagrid__pagination-found', grid).text(found);

				var items = [];
				for(var i = pageStart; i < pageEnd; i++)
				{
					var li = $('<li class="datagrid__pagination-page"><button data-offset="'+i+'">'+(i+1)+'</button></li>');
					if(offset == i) li.addClass('datagrid__pagination-page--active');
					items.push(li);
				}

				$('.datagrid__pagination-pages', pagination).html(items);

				grid.removeClass('datagrid__loading');

			});
		}
	});
});
