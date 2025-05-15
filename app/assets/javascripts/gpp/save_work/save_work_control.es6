import SaveWorkControl from 'hyrax/save_work/save_work_control'

export default class GppSaveWorkControl extends SaveWorkControl {
    activate() {
        super.activate();
        this.initializeDatesCoveredCallbacks();
        this.initializeRequiredReportField();
    }

    validateMetadata(e) {
        let titleValid = this.titleValidator();
        let descriptionValid = this.descriptionValidator();
        let subjectValid = this.publicationSubjectValidator();
        let datesCoveredValid = this.datesCoveredValidator();
        if (this.requiredFields.areComplete && titleValid && descriptionValid && subjectValid && datesCoveredValid) {
            this.requiredMetadata.check();
            return true;
        }
        this.requiredMetadata.uncheck();
        return false;
    }

    // Sets the files indicator to complete/incomplete
    validateFiles() {
        if (!this.uploads.hasFileRequirement) {
            return true
        }
        if (!this.isNew || this.uploads.hasFiles) {
            // Check for potential errors such as viruses
            let errors = $('span:contains("Error")');
            if (errors.length > 0) {
                this.requiredFiles.uncheck();
                return false;
            }
            this.requiredFiles.check();
            return true
        }
        this.requiredFiles.uncheck();
        return false
    }

    formChanged() {
        this.requiredFields.reload();
        this.initializeDatesCoveredCallbacks();
        this.formStateChanged();
        this.onAgencyChange();
        this.getReportDueDateId()
    }

    titleValidator() {
        let title = $('#nyc_government_publication_title');
        if (title.val().length < 10 || title.val().length > 150) {
            return false;
        }
        return true;
    }

    descriptionValidator() {
        let description = $('#nyc_government_publication_description');
        if (description.val().length < 100 || description.val().length > 300) {
            return false;
        }
        return true;
    }

    publicationSubjectValidator() {
        let selectedSubjects = $('#nyc_government_publication_subject option:selected');
        let subjectError = $('#publication-subject-error');
        if (selectedSubjects.length > 3) {
            subjectError.show();
            subjectError.focus();
            return false;
        }
        subjectError.hide();
        return true;
    }

    datesCoveredValidator() {
        let fiscalYear = $('#nyc_government_publication_fiscal_year');
        let calendarYear = $('#nyc_government_publication_calendar_year');
        if (fiscalYear.val().length === 0 && calendarYear.val().length === 0) {
            return false;
        }
        return true;
    }

    initializeDatesCoveredCallbacks() {
        $('#nyc_government_publication_fiscal_year').change(() => this.formStateChanged());
        $('#nyc_government_publication_calendar_year').change(() => this.formStateChanged());
    }

    initializeRequiredReportField() {
        let requiredReportField = $('#nyc_government_publication_required_report_name');

        if (requiredReportField.val() === '') {
            requiredReportField.prop('disabled', true);
        } else {
            let selectedAgency = $('#nyc_government_publication_agency').val();

            this.getAgencyRequiredReports(requiredReportField, selectedAgency, requiredReportField.val());
        }
    }

    getAgencyRequiredReports(requiredReportField, selectedAgency, selectedRequiredReport) {
        $.ajax({
            url: '/mandated_reports/agency_required_reports',
            type: 'GET',
            data: {'agency': selectedAgency},
            dataType: 'JSON',
            success: function(data) {
                let reportDueDate = $('#report_due_date_id');

                requiredReportField.empty();
                reportDueDate.val('');

                if (selectedAgency !== '') {
                    // Add blank option
                    requiredReportField.append(new Option('', ''));
                    data['required_report_names'].forEach(function (report) {
                        let option = new Option(report['report_name'] + ' (' + report['base_due_date'] + ')', report['report_name']);
                        option.setAttribute('report_due_date_id', report['report_due_date_id']);
                        requiredReportField.append(option);
                    });
                    // Add Not Required option
                    requiredReportField.append(new Option('Not Required', 'Not Required'));
                    requiredReportField.prop('disabled', false);
                    if (selectedRequiredReport !== null) {
                        requiredReportField.val(selectedRequiredReport);
                        reportDueDate.val(requiredReportField.find('option:selected').attr('report_due_date_id'));
                    }
                }
                else {
                    requiredReportField.prop('disabled', true);
                }
            },
            error: function(data) {}
        });
    }

    onAgencyChange() {
        let agency = $('#nyc_government_publication_agency');
        let requiredReportField = $('#nyc_government_publication_required_report_name');

        agency.change(() => {
            this.getAgencyRequiredReports(requiredReportField, agency.val(), null);
        });
    }

    getReportDueDateId() {
        let requiredReportField = $('#nyc_government_publication_required_report_name');

        requiredReportField.on('change', function() {
            $('#report_due_date_id').val(requiredReportField.find('option:selected').attr('report_due_date_id'));
        });
    }
}