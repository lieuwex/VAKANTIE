var target, time;

function fetch () {
	cb = function (res) {
		time = res;
		$("div.output")
			.text(res)
			.animate({ opacity: 1 });
	};

	$.get("/" + target, function (res) {
		cb("nog " + res + "...");
	}).fail(function () {
		cb("kadush");
	});
}

$(function () {
	if ('localStorage' in window && window['localStorage'] != null) {
		target = localStorage["target"];
		if (target != null) {
			$("input").val(target);
			fetch();
		}
	}

	$("input").keydown(function (event) {
		if (event.which !== 13) return;
		localStorage["target"] = target = event.target.value;
		$("input").blur();
		fetch();
	});

	$("input")
		.focus(function () {
			$(this).animate({ opacity: 1 });
		})
		.blur(function () {
			$(this).animate({ opacity: .6 });
		});
});
