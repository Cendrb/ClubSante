var current_therapy_id;

function setupHandlersForExercise(id) {

    setupUniversalTooltip($(".calendar_exercise[data-id=" + id + "]"));

    setupUniversalHandler($(".calendar_exercise[data-id=" + id + "][data-in-past=false]"));

    setupAdminEdit(".calendar_exercise[data-id=" + id + "]");
}

function setupHandlersForTemplate(id) {

    setupUniversalTooltip($(".calendar_template_exercise[data-id=" + id + "]"));

    setupUniversalHandler($(".calendar_template_exercise[data-id=" + id + "]"));

    setupAdminEdit(".calendar_template_exercise[data-id=" + id + "]");
}

function setupHandlersForModification(id) {

    setupUniversalTooltip($(".calendar_modification_exercise[data-id=" + id + "]"));

    setupUniversalHandler($(".calendar_modification_exercise[data-id=" + id + "]"));

    setupAdminEdit(".calendar_modification_exercise[data-id=" + id + "]");
}

function setupHandlersForCalendar(calendar_id) {
    var filter = "";
    if (calendar_id) {
        filter = "[data-calendar-id=" + calendar_id + "]";
    }

    setupUniversalTooltip($(".calendar_exercise_style" + filter));

    setupUniversalHandler($(".calendar_template_exercise" + filter));

    setupUniversalHandler($(".calendar_modification_exercise" + filter));

    setupUniversalHandler($(".calendar_exercise[data-in-past=false]" + filter));

    $(".calendar_week_selector_button" + filter).click(function (event) {
        NProgress.configure({
            showSpinner: true
        });
        NProgress.start();
        var clicked = $(this);
        $.ajax({
            type: "GET",
            url: "/calendars/" + clicked.data("calendar-id") + "/final.js",
            data: {target_date: clicked.data("target-date")},
            dataType: 'script',
            format: 'js',
            success: function (msg) {
                setupHandlersForCalendar(clicked.data("calendar-id"));
                refreshTicketsBar(current_therapy_id);
                NProgress.done();
                NProgress.configure({
                    showSpinner: false
                });
            }
        });
    });

    setupAdminEdit(".calendar_exercise_style" + filter);
}

function setupUniversalHandler(element) {
    element.click(function (event) {
        var clicked = $(this);
        var id = clicked.data("id");
        var beginning_offset = $(".calendar_timetable[data-calendar-id=" + clicked.data("calendar-id") + "]").data("beginning_offset")
        if (clicked.data("registered-by-current-user") == true) {
            if (confirm("Na toto cvičení jste již přihlášen. Chcete se z něj odhlásit?")) {
                $.ajax({
                    type: "POST",
                    url: "/registering_handler/unsubscribe_from",
                    data: {
                        id: id,
                        source: "calendar_view",
                        beginning_offset: beginning_offset
                    },
                    dataType: 'script',
                    format: 'js',
                    success: function (msg) {

                    }
                });
            }
        }
        else {
            $.ajax({
                type: "POST",
                url: "/registering_handler/subscribe",
                data: {
                    id: id,
                    beginning_offset: beginning_offset,
                    date: clicked.data("date"),
                    mode: clicked.data("mode")
                },
                dataType: 'script',
                format: 'js',
                success: function (msg) {

                }
            });
        }
    });
}

function setupUniversalTooltip(element) {
    element.tooltip({
        items: "[data-tooltip]",
        content: function () {
            return this.getAttribute("data-tooltip");
        }
    });
}

function setupAdminEdit(filter) {
    if (typeof admin !== 'undefined' && admin) {
        $(filter).unbind("click");
        $(filter).click(function (event) {
            var clicked = $(this);
            var id = clicked.data("id");
            var beginning_offset = $(".calendar_timetable[data-calendar-id=" + clicked.data("calendar-id") + "]").data("beginning_offset")
            $.ajax({
                type: "POST",
                url: "/registering_handler/admin_edit",
                data: {
                    id: id,
                    beginning_offset: beginning_offset,
                    mode: clicked.data("mode"),
                    date: clicked.data("date")
                },
                dataType: 'script',
                format: 'js',
                success: function (msg) {
                }
            });
        });
    }
}

function refreshTicketsBar(therapy_id) {
    $("#calendars_summary_tickets_list").html("Probíhá stahování dat...");
    $.ajax({
        type: "POST",
        url: "/reservations_ticket_view",
        data: {
            therapy_id: therapy_id,
            ticket_max_date: $(".week_selector_current_week").data("end")
        },
        dataType: 'script',
        format: 'js',
        success: function (msg) {
        }
    });
}

function setHeight() {
    if ($("#calendars_summary_calendars").length) {
        $("#yield").height(Math.max($("#calendars_summary_calendars").height() + 20, $("#calendars_summary_coaches").height() + 20));
    }
}

$(function () {
    setupHandlersForCalendar(null);

    $(function () {
        $("#calendars_summary_calendars").tabs();
    });

    $(".calendar-tab-anchor").click(function () {
        current_therapy_id = $(this).data("therapy-id");
        refreshTicketsBar(current_therapy_id);
        setHeight();
    });

    $(".calendar-tab-anchor").first().click();

    setHeight();
});
