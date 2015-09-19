$(function() {
    $(".info").tooltip({
        items: "[data-tooltip]",
        content: function () {
            return this.getAttribute("data-tooltip");
        }
    });
});