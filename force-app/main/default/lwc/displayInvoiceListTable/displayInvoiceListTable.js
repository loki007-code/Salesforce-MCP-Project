import { LightningElement, track, wire } from 'lwc';
import getInvoiceList from '@salesforce/apex/DisplayInvoiceListTable.getInvoiceList';
import getInvoiceLineById from '@salesforce/apex/DisplayInvoiceListTable.getInvoiceLineById';
import getAllProducts from '@salesforce/apex/DisplayInvoiceListTable.getAllProducts';
import saveInvoiceLine from '@salesforce/apex/DisplayInvoiceListTable.saveInvoiceLine';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const columns = [
    { label: 'Invoice Number', fieldName: 'NameUrl', type: 'url', sortable:true, typeAttributes: {
        label: { fieldName: 'Name' },
        tooltip: { fieldName: 'Name' },
    } },
    { label: 'Invoice Date', fieldName: 'Invoice_Date__c', type: 'date', sortable: true },
    {
        label: 'Buyer Name', fieldName: 'BuyerNameUrl', type: 'url', sortable:true, typeAttributes: {
            label: { fieldName: 'Buyer_Name__c' },
            tooltip: { fieldName: 'Buyer_Name_c' },
        }
    },
    { label: 'Invoice Status', fieldName: 'Invoice_Status__c', type: 'Picklist', sortable: true },
    {
        label: 'Open', type: 'button', typeAttributes: {
            label: 'View',
            name: 'view',
            title: 'Click to view Invoice',
            variant: 'brand',
            iconPosition: 'left'
        }
    }
];

const invoiceLineColumns = [
    { label: 'Product Name', fieldName: 'NameUrl', type: 'url', sortable: true, typeAttributes: {
        label: { fieldName: 'Name' },
        tooltip: { fieldName: 'Name' }
    } },
    { label: 'Quantity', fieldName: 'Quantity__c', type: 'number', sortable: true },
    { label: 'Price', fieldName: 'Price__c', type: 'currency', sortable: true },
    { label: 'Product Total', fieldName: 'Product_Total__c', type: 'currency', sortable: true },
    { label: 'Taxes', fieldName: 'Taxes__c', type: 'currency', sortable: true },
    { label: 'Grand Total', fieldName: 'Grand_Total__c', type: 'currency', sortable: true }
];

export default class DisplayInvoiceListTable extends NavigationMixin(LightningElement) {
    // Invoice table properties
    @track data;
    @track columns = columns;

    // pagination properties for Invoice table
    @track page = 1;
    @track pageSize = 5;
    @track totalPages;
    @track paginatedData = [];

    // Sorting properties for Invoice table
    @track sortBy;
    @track sortDirection;

    // Invoice Line table properties
    @track invoiceLineColumns = invoiceLineColumns;
    @track invoiceLineData;

    // invoice line pagination properties
    @track invoiceLinePage = 1;
    @track invoiceLinePageSize = 5;
    @track invoiceLineTotalPages;
    @track paginatedInvoiceLineData = [];

    // invoice line sorting properties
    @track invoiceLineSortBy;
    @track invoiceLineSortDirection;

    // UI state
    @track selectedInvoice;
    @track showInvoice = true;
    @track showInvoiceLine = false;
    @track showAddProduct = false;

    // Modal fields
    @track productOptions;
    @track productName;
    @track quantity;
    @track price;
    @track taxes;

    // Save Invoice Line logic
    @track invoiceLineList = [];

    // Invoice list data
    @wire(getInvoiceList)
    wiredInvoices({ error, data }) {
        if (data) {
            data = JSON.parse(JSON.stringify(data));
            this.data = data.map((res, index) => ({
                SNo: index + 1,
                Id: res.Id,
                NameUrl: res.Id ? '/' + res.Id : '',
                Name: res.Name,
                Invoice_Date__c: res.Invoice_Date__c,
                Invoice_Status__c: res.Invoice_Status__c,
                Buyer_Name__c: res.Buyer_Name__r?.Name,
                BuyerNameUrl: res.Buyer_Name__c ? '/' + res.Buyer_Name__c : '',
                BuyerId: res.Buyer_Name__r.Id,
                Seller_Name__c: res.Seller_Name__r?.Name,
                SellerNameUrl: res.Seller_Name__c ? '/' + res.Seller_Name__c : '',
                SellerId: res.Seller_Name__r.Id,
                Pending_Amount__c: res.Pending_Amount__c
            }));
            this.page = 1;
            this.paginateData();
        } else if (error) {
            console.error('Error fetching invoices', error);
        }
    }

    // Pagination for Invoice table
    paginateData() {
        const startIndex = (this.page - 1) * this.pageSize;
        const endIndex = startIndex + this.pageSize;
        this.paginatedData = this.data ? this.data.slice(startIndex, endIndex) : [];
        this.totalPages = this.data ? Math.ceil(this.data.length / this.pageSize) || 1 : 1;
    }
    get isFirstPage() { return this.page === 1; }
    get isLastPage() { return this.page === this.totalPages; }
    goToPreviousPage() { if (this.page > 1) { this.page--; this.paginateData(); } }
    goToNextPage() { if (this.page < this.totalPages) { this.page++; this.paginateData(); } }
    

    // Invoice Line table logic
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'view') {
            this.selectedInvoice = row;
            this.showInvoice = false;
            this.showInvoiceLine = true;
            this.getInvoiceLine();
        }
    }

    //back button logic in 2nd screen
    handleBack() {
        this.showInvoice = true;
        this.showInvoiceLine = false;
    }

    // Fetch Invoice Line data based on selected invoice
    getInvoiceLine() {
        getInvoiceLineById({ invoiceId: this.selectedInvoice.Id })
            .then(result => {
                this.invoiceLineData = result.map((res, index) => ({
                    SNo: index + 1,
                    Id: res.Id,
                    NameUrl: res.Product_Name__c ? '/' + res.Product_Name__c : '',
                    Name: res.Product_Name__r ? res.Product_Name__r.Name : '',
                    Quantity__c: res.Quantity__c,
                    Price__c: res.Price__c,
                    Product_Total__c: res.Product_Total__c,
                    Taxes__c: res.Taxes__c,
                    Grand_Total__c: res.Grand_Total__c
                }));
                this.invoiceLinePage = 1;
                this.paginateInvoiceLineData();
            })
            .catch(error => {
                console.error('Error fetching invoice lines', error);
            });
    }

    // Pagination for Invoice Line table
    paginateInvoiceLineData() {
        if (!this.invoiceLineData) {
            this.paginatedInvoiceLineData = [];
            this.invoiceLineTotalPages = 1;
            return;
        }
        const startIndex = (this.invoiceLinePage - 1) * this.invoiceLinePageSize;
        const endIndex = startIndex + this.invoiceLinePageSize;
        this.paginatedInvoiceLineData = this.invoiceLineData.slice(startIndex, endIndex);
        this.invoiceLineTotalPages = Math.ceil(this.invoiceLineData.length / this.invoiceLinePageSize) || 1;
    }
    get isInvoiceLineFirstPage() { return this.invoiceLinePage === 1; }
    get isInvoiceLineLastPage() { return this.invoiceLinePage === this.invoiceLineTotalPages; }
    goToInvoiceLinePreviousPage() { if (this.invoiceLinePage > 1) { this.invoiceLinePage--; this.paginateInvoiceLineData(); } }
    goToInvoiceLineNextPage() { if (this.invoiceLinePage < this.invoiceLineTotalPages) { this.invoiceLinePage++; this.paginateInvoiceLineData(); } }

    // Add Product Modal logic
    connectedCallback() { this.loadProduct(); }
    
    loadProduct() {
        getAllProducts()
            .then(result => {
                this.productOptions = result.map(res => ({
                    label: res.Name,
                    value: res.Id
                }));
            })
            .catch(error => {
                console.error('Error fetching products', error);
            });
    }

    // Handle input changes in the modal
    handleInputChange(event) {
        const field = event.target.name;
        this[field] = event.target.value;
    }

    // Save Invoice Line logic
    handleSave() {
        if (!this.productName || !this.quantity || !this.price || !this.taxes) {
            this.showToast('Missing Data', 'Please fill all fields before saving.', 'error');
            return;
        }
        const invoiceLine = {
            SobjectType: 'Invoice_Line__c',
            InvoiceM__c: this.selectedInvoice.Id,
            Product_Name__c: this.productName,
            Quantity__c: this.quantity,
            Price__c: this.price,
            Taxes__c: this.taxes,
        };
        this.invoiceLineList.push(invoiceLine);
        saveInvoiceLine({ invoiceLineList: this.invoiceLineList })
            .then(() => {
                this.showToast('Success', 'Invoice Line Records created successfully', 'success');
                this.showAddProduct = false;
                this.loadProduct();
                this.getInvoiceLine();
                this.productName = '';
                this.quantity = '';
                this.price = '';
                this.taxes = '';
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
                console.error('Error saving invoice line', error);
            });
    }

    // Show Add Product modal
    handleClick() {
        this.showAddProduct = true;
        this.loadProduct();
    }

    // Cancel Add Product modal
    handleCancel() {
        this.showAddProduct = false;
    }

    // Show toast messages
    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(toastEvent);
    }

    // Navigate to record page on click
    handleRecordClick(event) {
        const recordId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
    }

    // Reusable sort function
    sortArray(dataArray, fieldName, direction) {
        let parseData = JSON.parse(JSON.stringify(dataArray));
        let keyValue = (a) => a[fieldName];
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        return parseData;
    }

    // Invoice table sorting
    doSorting(event){
        const fieldName = event.detail.fieldName;
        let direction = event.detail.sortDirection;

        if (this.sortBy === fieldName) {
            direction = this.sortDirection === 'asc' ? 'desc' : 'asc';
        }
        this.sortBy = fieldName;
        this.sortDirection = direction;
        this.data = this.sortArray(this.data, fieldName, direction);
        this.page = 1;
        this.paginateData();
    }

    // Invoice Line table sorting
    doInvoiceLineSorting(event){
        const fieldName = event.detail.fieldName;
        let direction = event.detail.sortDirection;
        if (this.invoiceLineSortBy === fieldName) {
            direction = this.invoiceLineSortDirection === 'asc' ? 'desc' : 'asc';
        }
        this.invoiceLineSortBy = fieldName;
        this.invoiceLineSortDirection = direction;
        this.invoiceLineData = this.sortArray(this.invoiceLineData, fieldName, direction);
        this.invoiceLinePage = 1;
        this.paginateInvoiceLineData();
    }
}