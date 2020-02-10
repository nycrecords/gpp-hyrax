'use strict';

$(document).ready(function () {
    $('#required_report_start_date').inputmask(
        {
            alias: 'datetime',
            inputFormat: 'yyyy-mm-dd',
            placeholder: '_',
            showMaskOnHover: false,
            min: '01/01/1600'
        });

    $('#required_report_end_date').inputmask(
        {
            alias: 'datetime',
            inputFormat: 'yyyy-mm-dd',
            placeholder: '_',
            showMaskOnHover: false,
            min: '01/01/1600'
        });

    $('#new_required_report').submit(function (e) {
        let local_law_value_length = $('#required_report_local_law').val().length,
            charter_and_code_value_length = $('#required_report_charter_and_code').val().length,
            frequency_value = $('#required_report_frequency').val(),
            frequency_value_length = $('#required_report_frequency').val().length,
            frequency_integer_value_length = $('#required_report_frequency_integer').val().length,
            other_frequency_description_value_length = $('#required_report_other_frequency_description').val().length,
            start_date = $('#required_report_start_date').val(),
            end_date = $('#required_report_end_date').val();

        // Validate one of local_law or charter_and_code is provided
        if (local_law_value_length === 0 && charter_and_code_value_length === 0) {
            showError('One of Local Law or Charter and Code is required.');
            return false;
        }

        // other_frequency_description is empty
        if (other_frequency_description_value_length === 0) {
            // One of frequency or frequency_integer (if frequency is not Once) or start date is empty
            if (frequency_value_length === 0
                || (frequency_value !== 'Once' && frequency_integer_value_length === 0)
                || start_date.length === 0) {
                showError('Frequency, Frequency Integer and Start Date or Other frequency description is required.');
                return false;
            }
        } else { // other_frequency_description is not empty
            // One of frequency or frequency_integer is not empty
            if (frequency_value_length > 0 || frequency_integer_value_length > 0) {
                showError('Frequency and Frequency Integer or Other frequency description is required.');
                return false;
            }
        }

        // Validate end_date is before start_date if both values are provided
        if ((start_date && end_date) && (start_date > end_date)) {
            showError('End date should not be before the start date.');
            return false;
        }
    });

    // Display an error message to the user
    function showError(message) {
        let errorDiv = $('#new_required_report #alert-error');
        errorDiv.text(message);
        errorDiv.show();
        errorDiv.focus();
    }
});