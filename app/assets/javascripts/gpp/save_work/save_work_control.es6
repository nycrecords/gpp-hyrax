import SaveWorkControl from 'hyrax/save_work/save_work_control'

export default class GppSaveWorkControl extends SaveWorkControl {
    activate() {
        super.activate();
    }

    validateMetadata(e) {
        let subjectValid = this.publicationSubjectValidator();
        if (this.requiredFields.areComplete && subjectValid) {
            this.requiredMetadata.check();
            return true;
        }
        this.requiredMetadata.uncheck();
        return false;
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
}