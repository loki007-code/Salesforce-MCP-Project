import { LightningElement, track } from 'lwc';
import getAllCertifications from '@salesforce/apex/SelfCertificationController.getAllCertifications';

const columns = [
    { label: 'Country', fieldName: 'Country__c' },
    { label: 'Certification Date', fieldName: 'Certification_Date__c' },
    { label: 'Next Due Date', fieldName: 'Next_Due_Date__c' },
    { label: 'Certified By', fieldName: 'Certified_By_Name__c' },
    { label: 'Status', fieldName: 'Status__c' },
    { label: 'Email', fieldName: 'Email__c' }
];

export default class SelfCertificationAdmin extends LightningElement {
    @track allCertifications = [];
    @track certifications = [];

    @track countrySearch = '';
    @track certifiedBySearch = '';
    @track statusSearch = '';

    columns = columns;

    @track page = 1;
    @track pageSize = 5;
    @track totalPages;
    @track paginatedData = [];

    statusOptions = [
        { label: 'All', value: '' },
        { label: 'Submitted', value: 'Submitted' },
        { label: 'Approved', value: 'Approved' },
        { label: 'Rejected', value: 'Rejected' }
    ];

    connectedCallback() {
        this.loadAllCertifications();
    }

    loadAllCertifications() {
        getAllCertifications()
            .then(result => {
                this.allCertifications = this.flattenData(result);
                this.certifications = this.allCertifications;
                this.page = 1;
                this.paginateData();
            })
            .catch(error => {
                console.error('Error loading certifications:', JSON.stringify(error));
            });
    }

    flattenData(records) {
        return records.map(rec => ({
            ...rec,
            Certified_By_Name__c: rec.Certified_By__r ? rec.Certified_By__r.Name : ''
        }));
    }

    handleCountrySearch(event) {
        this.countrySearch = event.target.value.toLowerCase();
        this.applySearchFilter();
    }

    handleCertifiedBySearch(event) {
        this.certifiedBySearch = event.target.value.toLowerCase();
        this.applySearchFilter();
    }

    handleStatusChange(event) {
        this.statusSearch = event.detail.value;
        this.applySearchFilter();
    }

    applySearchFilter() {
        this.certifications = this.allCertifications.filter(rec => {
            const countryMatch = (rec.Country__c || '').toLowerCase().includes(this.countrySearch);
            const certifiedByMatch = (rec.Certified_By_Name__c || '').toLowerCase().includes(this.certifiedBySearch);
            const statusMatch = this.statusSearch === '' || rec.Status__c === this.statusSearch;
            return countryMatch && certifiedByMatch && statusMatch;
        });
        this.page = 1; // Reset to first page after filter
        this.paginateData(); // Update paginatedData after filter
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

    exportCSV() {
        let csv = 'Country,Certification Date,Next Due Date,Certified By,Status\n';
        this.certifications.forEach(rec => {
            csv += `"${rec.Country__c || ''}","${rec.Certification_Date__c || ''}","${rec.Next_Due_Date__c || ''}","${rec.Certified_By_Name__c || ''}","${rec.Status__c || ''}"\n`;
        });
        let element = document.createElement('a');
        element.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv);
        element.download = 'SelfCertifications.csv';
        document.body.appendChild(element);
        element.click();
        document.body.removeChild(element);
    }
}