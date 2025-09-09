class AgenciesManager {
    constructor(config) {
        this.config = Object.assign({}, AgenciesManager.defaults, config);
        this.init();
    }

    init() {
        this.registerEventHandlers();
        this.refreshTable();
    }

    registerEventHandlers() {
        var checkAllSelector = this.config.checkAllSelector;
        var deleteBtnSelector = this.config.deleteBtnSelector;
        var formSelector = this.config.formSelector;

        $(document)
            .on("change", checkAllSelector, this.toggleAllCheckboxes.bind(this))
            .on("change", this.config.checkboxSelector, this.toggleDeleteBtn.bind(this))
            .on("submit", formSelector, this.addItem.bind(this))
            .on("click", deleteBtnSelector, this.deleteItems.bind(this))
            .on("mousedown", this.resetInputState.bind(this));
    }

    toggleAllCheckboxes() {
        $(this.config.checkboxSelector).prop("checked", $(this.config.checkAllSelector).prop("checked"));
        this.toggleDeleteBtn();
    }

    toggleDeleteBtn() {
        $(this.config.deleteBtnSelector).toggle($(this.config.checkboxSelector + ":checked").length > 0);
    }

    resetInputState() {
        $(this.config.formSelector).removeClass("has-error");
        $(this.config.errorSelector).hide().text("");
    }

    addItem(e) {
        e.preventDefault();
        var input = $(this.config.inputSelector);
        var value = input.val();

        if (!value) return;

        $.ajax({
            url: this.config.createUrl,
            method: "POST",
            data: { new_item: value, id: this.config.agencyId },
            dataType: "json",
            success: (response) => {
                input.val("");
                this.resetInputState();
                this.showFlashMessage(response.message || "Added successfully");
                this.refreshTable(response.html);
                if (response.options_html) {
                    $(this.config.inputSelector).html(response.options_html);
                }
            },
            error: (xhr) => {
                var error = (xhr.responseJSON && xhr.responseJSON.error) || "Something went wrong.";
                $(this.config.formSelector).addClass("has-error");
                $(this.config.errorSelector).text(error).show();
            }
        });
    }

    deleteItems(e) {
        e.preventDefault();

        var indices = $(this.config.checkboxSelector + ":checked")
            .map(function () { return $(this).val(); })
            .get();

        if (indices.length === 0 || !confirm("Delete selected items?")) return;

        $.ajax({
            url: this.config.deleteUrl,
            method: "POST",
            data: { indices: indices, _method: "delete", id: this.config.agencyId },
            dataType: "json",
            success: (response) => {
                this.showFlashMessage(response.message || "Deleted successfully");
                this.refreshTable(response.html);
                if (response.options_html) {
                    $(this.config.inputSelector).html(response.options_html);
                }
            },
            error: (xhr) => {
                var error = (xhr.responseJSON && xhr.responseJSON.error) || "Something went wrong.";
                alert(error);
            }
        });
    }

    refreshTable(html) {
        if (!html) return;

        var table = $(this.config.tableSelector);
        if ($.fn.DataTable.isDataTable(table)) {
            table.DataTable().destroy();
        }

        $(this.config.tableBodySelector).html(html);

        table.DataTable({
            destroy: true,
            columnDefs: [{ orderable: false, targets: "no-sort" }]
        });

        $(this.config.checkAllSelector).prop("checked", false);
        this.toggleDeleteBtn();
    }

    showFlashMessage(message, type) {
        if (typeof type === "undefined") { type = "success"; }
        $(this.config.flashSelector)
            .attr("class", "alert alert-" + type)
            .attr("role", "alert")
            .text(message)
            .fadeIn()
            .delay(3000)
            .fadeOut();
    }
}

AgenciesManager.defaults = {
    checkAllSelector: "#check-all-items",
    checkboxSelector: ".agency-item-checkbox",
    formSelector: "#add-item-form",
    inputSelector: "#new-item-input",
    errorSelector: "#item-error-message",
    deleteBtnSelector: "#delete-item-btn",
    tableBodySelector: "#agency-item-rows",
    flashSelector: "#agency-flash-message"
};
