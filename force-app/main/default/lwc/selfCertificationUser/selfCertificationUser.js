import { LightningElement, track } from 'lwc';
import USER_ID from '@salesforce/user/Id';
import getUserDetails from '@salesforce/apex/SelfCertificationController.getUserDetails';
import getPricingData from '@salesforce/apex/SelfCertificationController.getPricingData';
import createSelfCertification from '@salesforce/apex/SelfCertificationController.createSelfCertification';
import uploadSignedPDF from '@salesforce/apex/SelfCertificationController.uploadSignedPDF';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getMyCertifications from '@salesforce/apex/SelfCertificationController.getMyCertifications';

const columns = [
    { label: 'Country', fieldName: 'Country__c' },
    { label: 'Certification Date', fieldName: 'Certification_Date__c' },
    { label: 'Next Due Date', fieldName: 'Next_Due_Date__c' },
    { label: 'Certified By', fieldName: 'Certified_By_Name__c' },
    { label: 'Status', fieldName: 'Status__c' },
    { label: 'Email', fieldName: 'Email__c' }
];

export default class SelfCertificationUser extends LightningElement {
    @track userName;
    @track userCountry;
    @track email;
    @track certPeriod = new Date().getFullYear();
    @track comments = '';
    @track confirmation = false;
    @track eSignature = false;
    @track pricingData = [];
    selectedFile;

    columns = columns;
    @track myCertifications = [];
    @track certifications = [];

    @track page = 1;
    @track pageSize = 5;
    @track totalPages;
    @track paginatedData = [];

    showForm = false;

    connectedCallback() {
        this.initializeUserData();
        this.loadAllCertifications();
    }

    initializeUserData() {
        getUserDetails({ userId: USER_ID })
            .then(user => {
                console.log('User Apex:', JSON.stringify(user));
                this.userName = user.Name || user.name;
                this.userCountry = user.Country || user.country;
                this.email = user.Email || user.email;
                
                return getPricingData({ country: this.userCountry });
            })
            .then(data => {
                this.pricingData = data;
                console.log('Pricing data:', JSON.stringify(data));
            })
            .catch(err => {
                console.error('Error in initializeUserData:', JSON.stringify(err));
                this.showToast('Error', err.body?.message || JSON.stringify(err), 'error');
            });
    }

    handleCommentsChange(e) { this.comments = e.target.value; }
    handleConfirmation(e) { this.confirmation = e.target.checked; }
    handleESignature(e) { this.eSignature = e.target.checked; }

    handleFileChange(e) {
        let file = e.target.files[0];
        if (file && file.type === "application/pdf") {
            this.selectedFile = file;   
            this.showToast('Success', 'PDF file selected successfully!', 'success');
        } else {
            this.selectedFile = null;
            this.showToast('Error', 'Please upload a valid PDF file.', 'error');
        }
    }

    handleSubmit() {
        if (!this.confirmation || !this.eSignature) {
            this.showToast('Error', 'Please confirm and provide e-signature.', 'error');
            return;
        }
        if (!this.selectedFile) {
            this.showToast('Error', 'Please select a PDF file.', 'error');
            return;
        }
        createSelfCertification({
            country: this.userCountry,
            period: this.certPeriod,
            comments: this.comments,
            email: this.email,
            userId: USER_ID
        })
        .then(recordId => {
            console.log('Created Self Certification record ID:', recordId);

            let reader = new FileReader();
            reader.onloadend = () => {
                let base64 = reader.result.split(',')[1];
                uploadSignedPDF({
                    selfCertId: recordId,
                    base64Data: base64,
                    fileName: this.selectedFile.name
                })
                .then(() => {
                    this.showToast('Success', 'Self-Certification created & PDF uploaded!', 'success');
                    
                    this.resetForm();
                    this.showForm = false;
                    this.loadAllCertifications();
                })
                .catch(err => {
                    console.error('Upload PDF error:', JSON.stringify(err));
                    this.showToast('Error', 'PDF upload failed: ' + (err.body?.message || JSON.stringify(err)), 'error');
                });
            };
            reader.readAsDataURL(this.selectedFile);
        })
        .catch(err => {
            console.error('Create record error:', JSON.stringify(err));
            this.showToast('Error', 'Failed to create certification: ' + (err.body?.message || JSON.stringify(err)), 'error');
        });
    }

    resetForm() {
        this.confirmation = false;
        this.eSignature = false;
        this.comments = '';
        this.selectedFile = null;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant, mode: 'dismissable' }));
    }

    loadAllCertifications() {
        getMyCertifications({ userId : USER_ID})
            .then(result => {
                this.myCertifications = this.flattenData(result);
                this.certifications = this.myCertifications;
                this.page = 1;
                this.paginateData();
            })
            .catch(error => {
                console.error('Error loading certifications:', JSON.stringify(error));
                this.showToast('Error', 'Failed to load certifications: ' + (error.body?.message || JSON.stringify(error)), 'error');
            });
    }

    flattenData(records) {
        return records.map(rec => ({
            ...rec,
            Certified_By_Name__c : rec.Certified_By__r ? rec.Certified_By__r.Name : ''
        }))
    }

    paginateData() {
        const startIndex = (this.page - 1) * this.pageSize;
        const endIndex = startIndex + this.pageSize;
        this.paginatedData = this.certifications ? this.certifications.slice(startIndex, endIndex) : [];
        this.totalPages = this.certifications ? Math.ceil(this.certifications.length / this.pageSize) || 1 : 1;
    }

    get isFirstPage() { return this.page === 1; }
    get isLastPage() { return this.page === this.totalPages; }
    goToPreviousPage() {
        if (this.page > 1) {
            this.page--;
            this.paginateData();
        }
    }
    goToNextPage() {
        if (this.page < this.totalPages) {
            this.page++;
            this.paginateData();
        }                   
    }

    handleClick(){
        this.showForm = true;
    }

    handleClose() {
        this.showForm = false;
        this.resetForm();
    }
}