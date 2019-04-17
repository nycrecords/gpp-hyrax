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
    }

    titleValidator() {
        let title = $("#nyc_government_publication_title");
        if (title.val().length < 10 || title.val().length > 150) {
            return false;
        }
        return true;
    }

    descriptionValidator() {
        let description = $("#nyc_government_publication_description");
        if (description.val().length < 100 || description.val().length > 300) {
            return false;
        }
        return true;
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