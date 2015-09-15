$(function(){
	$("#user_administration_accordion").accordion(
	{
		collapsible: true,
		heightStyle: "content"
	});
    $("#therapies_sortable").sortable(
        {
            update: function(event, ui)
            {
                $.ajax({
                    type: "POST",
                    url: "/therapies/sort",
                    data: {
                        data: $("#therapies_sortable").children().map(function(i, v){ return [[i, $(this).data("therapy-id")]] }).toArray()
                    },
                    dataType: 'script',
                    format: 'js',
                    success: function (msg) {
                    }
                });
            }
        }
    );
});