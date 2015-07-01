$(document).ready(function(){
		$(".new_records_user_select").change(function() {
			$.ajax({
				type: "POST",
				url: "/records/new_records",
				data: { user_id: $(this).val() },
				dataType: 'script',
				format: 'js'
			});
		});
	});