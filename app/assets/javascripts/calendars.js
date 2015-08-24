function setupHandlersFor(id)
{
	console.log(id);
	$(".calendar_exercise_style[data-id=" + id + "]").tooltip({
		items: "[data-tooltip]",
        content: function()
        {
          	return this.getAttribute("data-tooltip");
        }
 	});

	$(".calendar_exercise[data-id=" + id + "][data-in-past=false]").click(function(event)
	{
		var clicked = $(this);
		var id = clicked.data("id");
		if(clicked.data("registered-by-current-user") == true)
		{
			if(confirm("Na toto cvičení jste již přihlášen. Chcete se z něj odhlásit?"))
			{
				$.ajax({
					type: "POST",
					url: "/registering_handler/unsubscribe_from",
					data: { exercise_id: id, source: "calendar_view", beginning_offset: $(".calendar_timetable[data-calendar-id=" + clicked.data("calendar-id") + "]").data("beginning_offset") },
					dataType: 'script',
					format: 'js',
					success: function(msg){
						//setupHandlersFor(id);
					}
				});
			}
		}
		else
		{
			$.ajax({
				type: "POST",
				url: "/registering_handler/subscribe_for_existing",
				data: { exercise_id: id, beginning_offset: $(".calendar_timetable[data-calendar-id=" + clicked.data("calendar-id") + "]").data("beginning_offset") },
				dataType: 'script',
				format: 'js',
				success: function(msg){
					//setupHandlersFor(id);
				}
			});
		}
	});
}

function setupHandlersForTemplate(id)
{
	console.log(id);
	$(".calendar_exercise_style[data-id=" + id + "]").tooltip({
		items: "[data-tooltip]",
        content: function()
        {
          	return this.getAttribute("data-tooltip");
        }
 	});

 	$(".calendar_template_exercise[data-id=" + id + "]").click(function(event)
	{
		var clicked = $(this);
		$.ajax({
			type: "POST",
			url: "/registering_handler/subscribe_for_template",
			data: { exercise_template_id: clicked.data("id"), date: clicked.data("date"), beginning_offset: $(".calendar_timetable[data-calendar-id=" + clicked.data("calendar-id") + "]").data("beginning_offset") },
			dataType: 'script',
			format: 'js',
			success: function(msg){

			}
		});
	});
}

function setupHandlersForModification(id)
{
	console.log(id);
	$(".calendar_exercise_style[data-id=" + id + "]").tooltip({
		items: "[data-tooltip]",
        content: function()
        {
          	return this.getAttribute("data-tooltip");
        }
 	});

 	$(".calendar_modification_exercise[data-id=" + id + "]").click(function(event)
	{
		var clicked = $(this);
		$.ajax({
			type: "POST",
			url: "/registering_handler/subscribe_for_modification",
			data: { exercise_modification_id: clicked.data("id"), beginning_offset: $(".calendar_timetable[data-calendar-id=" + clicked.data("calendar-id") + "]").data("beginning_offset") },
			dataType: 'script',
			format: 'js',
			success: function(msg){

			}
		});
	});
}

function setupHandlersForCalendar(calendar_id)
{
	var filter = "";
	if(calendar_id)
	{
		filter = "[data-calendar-id=" + calendar_id + "]";
	}

	$(".calendar_exercise_style" + filter).tooltip({
	items: "[data-tooltip]",
    content: function()
    {
      	return this.getAttribute("data-tooltip");
    }
 	});

 	$(".calendar_template_exercise" + filter).click(function(event)
	{
		var clicked = $(this);
		$.ajax({
			type: "POST",
			url: "/registering_handler/subscribe_for_template",
			data: { exercise_template_id: clicked.data("id"), date: clicked.data("date"), beginning_offset: $(".calendar_timetable" + filter).data("beginning_offset") },
			dataType: 'script',
			format: 'js',
			success: function(msg){

			}
		});
	});

	$(".calendar_modification_exercise" + filter).click(function(event)
	{
		var clicked = $(this);
		$.ajax({
			type: "POST",
			url: "/registering_handler/subscribe_for_modification",
			data: { exercise_modification_id: clicked.data("id"), beginning_offset: $(".calendar_timetable" + filter).data("beginning_offset") },
			dataType: 'script',
			format: 'js',
			success: function(msg){
				//setupHandlersFor(clicked.data("id"));
			}
		});
	});

	$(".calendar_exercise[data-in-past=false]" + filter).click(function(event)
	{
		var clicked = $(this);
		var id = clicked.data("id");
		if(clicked.data("registered-by-current-user") == true)
		{
			if(confirm("Na toto cvičení jste již přihlášen. Chcete se z něj odhlásit?"))
			{
				$.ajax({
					type: "POST",
					url: "/registering_handler/unsubscribe_from",
					data: { exercise_id: id, source: "calendar_view", beginning_offset: $(".calendar_timetable" + filter).data("beginning_offset") },
					dataType: 'script',
					format: 'js',
					success: function(msg){
						//setupHandlersFor(id);
					}
				});
			}
		}
		else
		{
			$.ajax({
				type: "POST",
				url: "/registering_handler/subscribe_for_existing",
				data: { exercise_id: id, beginning_offset: $(".calendar_timetable" + filter).data("beginning_offset") },
				dataType: 'script',
				format: 'js',
				success: function(msg){
					//setupHandlersFor(id);
				}
			});
		}
	});

	$(".calendar_week_selector_button" + filter).click(function(event)
	{
		var clicked = $(this);
		$.ajax({
			type: "GET",
			url: "/calendars/" + clicked.data("calendar-id") + "/final.js",
			data: { target_date: clicked.data("target-date") },
			dataType: 'script',
			format: 'js',
			success: function(msg){
				setupHandlersForCalendar(clicked.data("calendar-id"));
			}
		});
	});

}

$(function(){
	setupHandlersForCalendar(null);

    Turbolinks.ProgressBar.enable();
});
