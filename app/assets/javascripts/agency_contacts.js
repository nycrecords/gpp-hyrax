$(document).ready(function () {
    const agencyId = $("#agency").data("agency-id");
    const emailForm = $("#add-email-form");
    const emailInput = $("#new-email-input");
    const emailError = $("#email-error-message");
    const deleteEmailBtn = $("#delete-email-btn");
    const checkAll = $("#check_all");
    const agencyFlashMessage = $("#agency-flash-message");
    const agencyContactRows = $("#agency-contact-rows");

    registerEventHandlers();

    function registerEventHandlers() {
        $(document)
            .on("change", "#check_all", toggleAllCheckboxes)
            .on("change", ".email-checkbox", toggleDeleteBtn)
            .on("submit", "#add-email-form", addEmail)
            .on("click", "#delete-email-btn", deleteSelectedEmail)
            .on("mousedown", resetEmailState);
    }

    function toggleAllCheckboxes() {
        $(".email-checkbox").prop("checked", this.checked);
        toggleDeleteBtn();
    }

    function toggleDeleteBtn() {
        // Toggle delete button based on whether any checkboxes are selected
        deleteEmailBtn.toggle($(".email-checkbox:checked").length > 0);
    }

    function showFlashMessage(message, type = "success") {
        agencyFlashMessage
            .attr("class", `alert alert-${type}`)
            .attr("role", "alert")
            .text(message)
            .fadeIn()
            .delay(3000)
            .fadeOut();
    }

    function refreshContactsTable(html) {
        const agencyContactsTable = $(".agency-contacts-table");

        // Reset DataTable
        if ($.fn.DataTable.isDataTable(agencyContactsTable)) {
            agencyContactsTable.DataTable().destroy();
        }

        // Repopulate table rows
        agencyContactRows.html(html);

        agencyContactsTable.DataTable({
            destroy: true,
            columnDefs: [{ orderable: false, targets: "no-sort" }]
        });

        // Uncheck "check all" and update delete button state
        checkAll.prop("checked", false);
        toggleDeleteBtn();
    }

    function resetEmailState() {
        emailForm.removeClass("has-error");
        emailError.hide().text("");
    }

    function addEmail(e) {
        e.preventDefault();

        // Perform HTML5 validation on the input
        if (!emailInput[0].checkValidity()) {
            emailInput[0].reportValidity();
            return false;
        }

        const email = emailInput.val();

        $.ajax({
            url: `/agency_contacts`,
            method: "POST",
            data: { new_email: email, id: agencyId },
            dataType: "json",
            success: function (response) {
                emailInput.val("");
                resetEmailState();
                showFlashMessage(response.message || "Email added successfully");
                refreshContactsTable(response.html);
            },
            error: function (xhr) {
                const errorMsg = (xhr.responseJSON && xhr.responseJSON.error) || "Something went wrong.";
                emailForm.addClass("has-error");
                emailError.addClass("has-error").text(errorMsg).show();
            }
        });
    }

    function deleteSelectedEmail(e) {
        e.preventDefault();

        const indices = $(".email-checkbox:checked")
            .map(function () {
                return $(this).val();
            })
            .get();

        if (indices.length === 0 || !confirm("Are you sure you want to delete the selected email(s)?")) return;

        $.ajax({
            url: `/agency_contacts/${agencyId}`,
            method: "POST",
            data: { indices, _method: "delete" },
            dataType: "json",
            success: function (response) {
                showFlashMessage(response.message || "Email(s) deleted.");
                refreshContactsTable(response.html);
            },
            error: function (xhr) {
                const errorMsg = (xhr.responseJSON && xhr.responseJSON.error) || "Something went wrong.";
                alert(errorMsg);
            }
        });
    }
});
