import SaveWorkControl from 'hyrax/save_work/save_work_control'

export default class GppSaveWorkControl extends SaveWorkControl {
    activate() {
        super.activate();
        this.initializeDatesCoveredCallbacks();
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

    formChanged() {
        this.requiredFields.reload();
        this.initializeDatesCoveredCallbacks();
        this.formStateChanged();
        this.getAgencyRequiredReports();
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

    getAgencyRequiredReports() {
        let agency = $('#nyc_government_publication_agency');
        let required_report = $('#nyc_government_publication_required_report_type');
        agency.change(function() {
            let selectedAgency = agency.val();
            $.ajax({
                url: '/required_reports/agency_required_reports',
                type: 'GET',
                data: {'agency': selectedAgency},
                dataType: 'JSON',
                success: function(data) {
                    if (selectedAgency !== '') {
                        required_report.empty();
                        // Add blank option
                        required_report.append(new Option('', ''));
                        data['report_names'].forEach(function (report) {
                            required_report.append(new Option(report, report));
                        });
                        // Add Not Required option
                        required_report.append(new Option('Not Required', 'Not Required'));
                        required_report.prop('disabled', false);
                    }
                    else {
                        required_report.empty();
                        required_report.prop('disabled', true);
                    }
                },
                error: function(data) {}
            });
        });
    }
}