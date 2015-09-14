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
                console.log($("#therapies_sortable").children().data("therapy-id"));
            }
        }
    );
});