$(document).ready(function() {
	$(window).hashchange(function() {
		var dehash = location.hash.split(':'),
			container = dehash[0],
			url = dehash[1];

		ColdFusion.navigate(url, container);
	});
});

application = {
	url: 'http://localhost:8500/contactor/action.cfm'
}

function action(section, item) {
}
