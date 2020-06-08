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
});