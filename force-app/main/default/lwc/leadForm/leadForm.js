import { LightningElement, track } from 'lwc';
import createLead from '@salesforce/apex/LeadFormController.createLead';

export default class LeadForm extends LightningElement {
    @track firstName = '';
    @track lastName = '';
    @track company = '';
    @track email = '';
    @track phone = '';
    @track message = '';

    handleChange(event) {
        this[event.target.name] = event.target.value;
    }

    async handleSubmit(event) {
        event.preventDefault();
        try {
            const result = await createLead({
                firstName: this.firstName,
                lastName: this.lastName,
                company: this.company,
                email: this.email,
                phone: this.phone
            });
            if (result === 'Success') {
                this.firstName = '';
                this.lastName = '';
                this.company = '';
                this.email = '';
                this.phone = '';
                this.message = 'Lead created successfully! Good decisions start here.';
            } else {
                this.message = result;
            }
        } catch (error) {
            this.message = error.body.message;
        }
    }
}
