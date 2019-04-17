import SaveWorkControl from 'hyrax/save_work/save_work_control'

export default class GppSaveWorkControl extends SaveWorkControl {
    activate() {
        super.activate();
        this.initializeDatesCoveredCallbacks();
    }

    validateMetadata(e) {
        let subjectValid = this.publicationSubjectValidator();
        let datesCoveredValid = this.datesCoveredValidator();
        if (this.requiredFields.areComplete && subjectValid && datesCoveredValid) {
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
    }

    publicationSubjectValidator() {
        let selectedSubjects = $("#nyc_government_publication_subject option:selected");
        let subjectError = $("#publication-subject-error");
        if (selectedSubjects.length > 3) {
            subjectError.show();
            subjectError.focus();
            return false;
        }
        subjectError.hide();
        return true;
    }

    datesCoveredValidator() {
        let fiscalYear = $("#nyc_government_publication_fiscal_year");
        let calendarYear = $("#nyc_government_publication_calendar_year");
        if (fiscalYear.val().length === 0 && calendarYear.val().length === 0) {
            return false;
        }
        return true;
    }

    initializeDatesCoveredCallbacks() {
        $("#nyc_government_publication_fiscal_year").change(() => this.formStateChanged());
        $("#nyc_government_publication_calendar_year").change(() => this.formStateChanged());
    }
}