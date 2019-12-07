import { Component, OnInit } from '@angular/core';
import { Store, select } from '@ngrx/store';
import { Observable } from 'rxjs';
import * as fromAuth from '../../../auth/reducers';
import { UserActions } from '../../../core/actions';
import { AuthActions } from '../../../auth/actions';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
	selector: 'app-header',
	templateUrl: './header.component.html',
	styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {
	username$: Observable<String>;
	loggedIn$: Observable<boolean>;

	constructor(
		private authStore: Store<fromAuth.State>,
		private modalService: NgbModal
	) {
		this.username$ = this.authStore.pipe(select(fromAuth.selectDisplayName));
		this.loggedIn$ = this.authStore.pipe(select(fromAuth.selectLoggedIn));
	}

	ngOnInit() {
		this.authStore.dispatch(UserActions.requestProfile());
	}

	logout() {
		this.authStore.dispatch(AuthActions.logoutConfirmation());
		return false;
	}
}
