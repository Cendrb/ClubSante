$(document).ready(function(){
		$(".new_records_user_select").change(function() {
			$.ajax({
				type: "GET",
				url: "/records/new",
				data: { user_id: $(this).val() },
				dataType: 'script',
				format: 'js'
			});
		});
	});