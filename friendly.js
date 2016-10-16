function _count (count) {
	return [
		"nul",
		"één",
		"twee",
		"drie",
		"vier",
		"vijf",
		"zes",
		"zeven",
		"acht",
		"negen",
		"tien",
		"elf",
		"twaalf",
		"dertien",
		"viertien",
		"vijftien",
		"zestien",
		"zeventien",
		"achtien",
		"negentien",
		"twintig"
	][count] || count.toString();
}
function _pluralize (amount, words) {
	var amount = ~~amount;
	return _count(amount) + " " + words[+(amount !== 1)];
}
function months (months) { return _pluralize(months, ["maand", "maanden"]);  }
function weeks (weeks) { return _pluralize(weeks, ["week", "weken"]);  }
function days (days) { return _pluralize(days, ["dag", "dagen"]);  }

module.exports = function (duration) {
	var leftDays = duration.asDays();
	var leftWeeks = leftDays / 7;
	var leftMonths = duration.asMonths();

	if (leftMonths > 2) {
		return "ongeveer " + months(leftMonths);
	} else if (leftMonths > 1) {
		var s = months(leftMonths);
		var leftWeeks = leftWeeks % 4;

		if (leftWeeks === 0) {
			return s;
		} else if (~~leftWeeks === 0) {
			return "ongeveer " + s;
		} else if (leftWeeks%1 === 0) {
			return s + " en " + weeks(leftWeeks % 4);
		} else {
			return s + " en ongeveer " + weeks(leftWeeks % 4);
		}
	} else {
		if (~~leftDays % 7 === 0) {
			return weeks(leftWeeks);
		} else if (leftDays > 7) {
			return weeks(leftWeeks) + " en " + days(leftDays % 7);
		} else {
			return days(leftDays % 7);
		}
	}
};
