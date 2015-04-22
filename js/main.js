var target;

function fetch () {
	function set (res) {
		$("div.output")
			.text(res)
			.animate({ opacity: 1 });
		$("input").blur();
	}

	$.getJSON("/" + target, function (res) {
		set("nog " + res.friendly + "...");
	}).fail(function (obj) {
		if (obj.status === 404) {
			set('geen plaats met de naam "' + target + '" gevonden.')
		} else {
			set("kadush");
		}
	});
}

$(function () {
	if ('localStorage' in window && window['localStorage'] != null) {
		target = localStorage["target"];
		if (target !== null) {
			$("input").val(target);
			fetch();
		}
	}

	$("input").keydown(function (event) {
		if (event.which === 13) {
			localStorage["target"] = target = event.target.value;
			fetch();
		}
	});
});
