import { LightningElement, wire } from 'lwc';
import getReportEmbeddingData from '@salesforce/apex/PowerBiEmbedManager.getReportEmbeddingData';

export default class PowerBiReportDataTest extends LightningElement {
    @wire(getReportEmbeddingData) report;
}