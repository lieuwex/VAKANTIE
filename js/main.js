function setValue (target) {
	localStorage["target"] = target;

	if (target != null) {
		$("input").val(target);
		fetch(target);
	}
}

function fetch (target) {
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
		var target = localStorage["target"];
		setValue(target);
	}

	$("input").keydown(function (event) {
		if (event.which === 13) {
			setValue(event.target.value);
		}
	});
});
