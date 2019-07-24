import editor from 'hyrax/editor'
import GppSaveWorkControl from 'gpp/save_work/save_work_control'

export default class extends editor {
    saveWorkControl() {
        new GppSaveWorkControl(this.element.find('#form-progress'), this.adminSetWidget)
    }
}