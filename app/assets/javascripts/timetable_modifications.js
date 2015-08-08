$(document).ready(function(){
	
	function setupHandlersForTimetableModification()
	{
		$(".timetable_week_selector_button").click(function(event)
		{
			var clicked = $(this);
			$.ajax({
				type: "GET",
				url: "/timetable_modifications/" + clicked.data("timetable-modification-id") + "/edit",
				data: { target_date: clicked.data("target-date") },
				dataType: 'script',
				format: 'js',
				success: function(msg){
					setupHandlersForTimetableModification();
				}
			});
		});
	}
	
	setupHandlersForTimetableModification();
});