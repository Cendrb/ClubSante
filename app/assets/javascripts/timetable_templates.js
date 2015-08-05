$(document).ready(function(){
	function setupHandlersForTimetableTemplate(timetable_template_id)
	{
		
	}

	$(".timetable_week_selector_button").click(function(event)
	{
		var clicked = $(this);
		$.ajax({
			type: "GET",
			url: "/timetable_templates/" + clicked.data("data-timetable-template-id") + ".js",
			data: { target_date: clicked.data("target-date") },
			dataType: 'script',
			format: 'js',
			success: function(msg){
				setupHandlersForTimetableTemplate(clicked.data("data-timetable-template-id"));
			}
		});
	});
});