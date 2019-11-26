import { Injectable } from '@angular/core';
import { HttpErrorResponse } from '@angular/common/http';
import { ErrorHandlerDataDTO } from '../models/dto';

@Injectable({
	providedIn: 'root'
})
export class ApiErrorHandlerService {

	constructor() { }

	handleHttpUnauthorized() {
		console.log('not authorized');
	}

	handleError(error: Error, data?: ErrorHandlerDataDTO) {
		if (error instanceof HttpErrorResponse) {
			const response: HttpErrorResponse = error;

			switch(response.status) {
				case 401:
					return this.handleHttpUnauthorized();
				default:
					console.log('Error: ', error);
					break;
			}
		}
	}
}