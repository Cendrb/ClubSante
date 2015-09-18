var clickedOnExercise = false;

function setupHandlersForTimetableModification() {
    $(".timetable_modification_style").tooltip({
        items: "[data-tooltip]",
        content: function () {
            return this.getAttribute("data-tooltip");
        }
    });

    $(".timetable_week_selector_button").click(function (event) {
        var clicked = $(this);
        $.ajax({
            type: "GET",
            url: "/timetable_modifications/" + clicked.data("timetable-modification-id") + "/edit",
            data: {target_date: clicked.data("target-date")},
            dataType: 'script',
            format: 'js',
            success: function (msg) {
                setupHandlersForTimetableModification();
            }
        });
    });

    $(".timetable_modification_template").mousedown(function (event) {
        clickedOnExercise = true;
        var clicked = $(this);
        var id = clicked.data("id");
        $.ajax({
            type: "GET",
            url: "/exercise_modifications/new",
            data: {exercise_template_id: id, date: clicked.data("date"), calendar_id: clicked.data("calendar-id")},
            dataType: 'script',
            format: 'js',
            success: function (msg) {
            }
        });
    });

    $(".timetable_modification_modification").mousedown(function (event) {
        clickedOnExercise = true;
        var clicked = $(this);
        var id = clicked.data("id");
        if (event.button == 2) {
            $.ajax({
                type: "POST",
                url: "/exercise_modifications/" + id,
                data: {_method: "delete"},
                dataType: 'script',
                format: 'js',
                success: function (msg) {
                }
            });
        }
        else {
            $.ajax({
                type: "GET",
                url: "/exercise_modifications/" + id + "/edit",
                data: {},
                dataType: 'script',
                format: 'js',
                success: function (msg) {
                }
            });
        }
    });

    $(".timetable_modification_weekday").mouseup(function (event) {
        if (!clickedOnExercise) {
            var clicked = $(this);
            var relativeYMinutes = (event.pageY - clicked.offset().top) / 1;
            var beginningHours = Math.floor(relativeYMinutes / 60);
            var beginningMinutes = Math.floor((relativeYMinutes % 60) / 10 * 2);
            $.ajax({
                type: "GET",
                url: "/exercise_modifications/new",
                data: {
                    datetime: clicked.data("date") + " " + beginningHours + ":" + beginningMinutes + " UTC",
                    calendar_id: clicked.data("calendar-id")
                },
                dataType: 'script',
                format: 'js',
                success: function (msg) {
                }
            });
        }
    });
}

$(function () {
    setupHandlersForTimetableModification();
});
