'use strict';

$(document).ready(function () {
    // Get current values from URL query string
    let agencyFilter = $('#agency-filter');
    let url = new URL(window.location.href);
    let params = new URLSearchParams(url.search);
    let agency = params.get('agency') || 'All';

    // Initialize select2 and set initial value
    agencyFilter.select2();
    agencyFilter.select2('val', agency);
    $('#s2id_agency-filter').attr('aria-label', 'Filter required reports by agency');

    // Handle change of agency event
    agencyFilter.on('change', function (data) {
        agency = data.val;
        params.set('agency', agency);
        params.delete('page');
        url.search = params.toString();
        window.location.href = url.toString();
    })

    // Handle required report visibility
    $('.visibility-checkbox').on('change', function() {
        const reportId = $(this).data('report-id');
        const isVisible = $(this).is(':checked');

        $.ajax({
            url: `/required_reports/${reportId}/toggle_visibility`,
            type: 'PATCH',
            dataType: 'json',
            contentType: 'application/json',
            data: JSON.stringify({ required_report: { is_visible: isVisible } }),
            success: function(data) {
                if (data.success) {
                    console.log('Visibility updated successfully');
                } else {
                    console.error('Error updating visibility:', data.error);
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error('AJAX error:', textStatus, errorThrown);
                console.error('Response text:', jqXHR.responseText);
            }
        });
    });

    // Show/Hide checkbox visibility tooltip
    $('[data-toggle="show-hide-tooltip"]').tooltip({trigger: 'hover focus'});
});
