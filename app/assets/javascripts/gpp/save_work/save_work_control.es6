import SaveWorkControl from 'hyrax/save_work/save_work_control'

export default class GppSaveWorkControl extends SaveWorkControl {
    activate() {
        super.activate();
    }

    isValid() {
        // EDIT THIS FUNCTION WITH CUSTOM VALIDATORS
        return false;
    }

    customValidator() {
        // WRITE CUSTOM VALIDATOR LOGIC HERE
        return false;
    }
}