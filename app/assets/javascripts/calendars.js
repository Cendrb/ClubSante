$(document).ready(function(){
	function setupHandlersFor(id)
	{
		$(".calendar_exercise_style[data-id=" + id + "]").tooltip({
			items: "[data-tooltip]",
	        content: function()
	        {
	          	return this.getAttribute("data-tooltip");
	        }
     	});
		$(".calendar_exercise[data-id=" + id + "]").click(function(event)
		{
			var clicked = $(this);
			if(clicked.data("registered-by-current-user") == true)
			{
				if(confirm("Na toto cvičení jste již přihlášen. Chcete se z něj odhlásit?"))
				{
					$.ajax({
						type: "POST",
						url: "/users/unsubscribe_from",
						data: { exercise_id: clicked.data("id"), source: "calendar_view", beginning_offset: $("#calendar_timetable").data("beginning_offset") },
						dataType: 'script',
						format: 'js',
						success: function(msg){
							setupHandlersFor(clicked.data("id"));
						}
					});
				}
			}
			else
			{
				$.ajax({
					type: "POST",
					url: "/users/subscribe_for_existing",
					data: { exercise_id: clicked.data("id"), beginning_offset: $("#calendar_timetable").data("beginning_offset") },
					dataType: 'script',
					format: 'js',
					success: function(msg){
						setupHandlersFor(clicked.data("id"));
					}
				});
			}
		});
	}
	$(".calendar_template_exercise").click(function(event)
		{
			var clicked = $(this);
			$.ajax({
				type: "POST",
				url: "/users/subscribe_for_new",
				data: { exercise_template_id: clicked.data("id"), date: clicked.data("date"), beginning_offset: $("#calendar_timetable").data("beginning_offset") },
				dataType: 'script',
				format: 'js',
				success: function(msg){
					setupHandlersFor(clicked.data("id"));
				}
			});
		});
	
	$(".calendar_exercise_style").tooltip({
		items: "[data-tooltip]",
        content: function()
        {
          	return this.getAttribute("data-tooltip");
        }
     });	
	
	$(".calendar_exercise").click(function(event)
		{
			var clicked = $(this);
			if(clicked.data("registered-by-current-user") == true)
			{
				if(confirm("Na toto cvičení jste již přihlášen. Chcete se z něj odhlásit?"))
				{
					$.ajax({
						type: "POST",
						url: "/users/unsubscribe_from",
						data: { exercise_id: clicked.data("id"), source: "calendar_view", beginning_offset: $("#calendar_timetable").data("beginning_offset") },
						dataType: 'script',
						format: 'js',
						success: function(msg){
							setupHandlersFor(clicked.data("id"));
						}
					});
				}
			}
			else
			{
				$.ajax({
					type: "POST",
					url: "/users/subscribe_for_existing",
					data: { exercise_id: clicked.data("id"), beginning_offset: $("#calendar_timetable").data("beginning_offset") },
					dataType: 'script',
					format: 'js',
					success: function(msg){
						setupHandlersFor(clicked.data("id"));
					}
				});
			}
		});
});
