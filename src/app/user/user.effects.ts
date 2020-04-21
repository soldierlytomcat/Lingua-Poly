import { Injectable } from '@angular/core';
import { fromEvent, merge, timer, of } from 'rxjs';
import { createEffect, Actions, ofType } from '@ngrx/effects';
import { map, exhaustMap, switchMapTo, catchError, tap, switchMap } from 'rxjs/operators';
import { UserApiActions } from './actions';
import { Router } from '@angular/router';
import * as fromAuth from '../auth/reducers'
import { Store } from '@ngrx/store';
import { UsersService } from '../core/openapi/lingua-poly';
import { ModalDialogService } from '../core/services/modal-dialog.service';
import { DeleteAccountConfirmationComponent } from './components/delete-account-confirmation/delete-account-confirmation.component';
import { UserActions, MessageActions } from '../core/actions';

@Injectable()
export class UserEffects {
	getProfile$ = createEffect(() => this.actions$.pipe(
		ofType(UserActions.requestProfile),
		exhaustMap(() =>
			this.usersService.profileGet().pipe(
				map(user => UserApiActions.profileSuccess({ user })),
				catchError(error => of(UserApiActions.profileFailure({ error })))
			)
		)
	));

	setProfile$ = createEffect(() => this.actions$.pipe(
		ofType(UserActions.setProfile),
		exhaustMap((props) =>
			this.usersService.profilePatch(props.payload).pipe(
				tap(() => this.authStore.dispatch(UserActions.requestProfile())),
				tap(() => this.router.navigate(['/'])),
				catchError(error => of(UserApiActions.profileFailure({ error })))
			)
		)
	), { dispatch: false });

	changePassword$ = createEffect(() => this.actions$.pipe(
		ofType(UserActions.changePassword),
		exhaustMap(props =>
			this.usersService.passwordPatch(props.payload).pipe(
				tap(() => this.router.navigate(['/'])),
				map(() => MessageActions.displayError({ code: 'STATUS_PASSWORD_CHANGED' })),
				catchError(error => of(UserApiActions.changePasswordFailure({ error })))
			)
		)
	));

	changePasswordWithToken$ = createEffect(() => this.actions$.pipe(
		ofType(UserActions.changePasswordWithToken),
		exhaustMap(props =>
			this.usersService.passwordResetPost(props.payload).pipe(
				map(user => UserApiActions.changePasswordWithTokenSuccess({ user })),
				tap(() => this.router.navigate(['/'])),
				catchError(error => of(UserApiActions.changePasswordFailure({ error })))
			)
		)
	));

	changePasswordWithTokenSuccess$ = createEffect(() => this.actions$.pipe(
		ofType(UserApiActions.changePasswordWithTokenSuccess),
		map(() => MessageActions.displayError({ code: 'STATUS_PASSWORD_CHANGED' })),
	));

	changePasswordFailure$ = createEffect(() => this.actions$.pipe(
		ofType(UserApiActions.changePasswordFailure),
		map(props => {
			let code;
			switch (props.error.code) {
				case 400:
					code = 'ERROR_WEAK_PASSWORD';
					break;
				case 401:
					code = 'ERROR_NOT_LOGGED_IN';
					break;
				case 410:
					code = 'ERROR_TOKEN_EXPIRED';
					break;
				default:
					code = 'ERROR_PASSWORD_CHANGE_FAILED';
					break;
			}
			return MessageActions.displayError({ code });
		}),
	));

	resetPassword$ = createEffect(() => this.actions$.pipe(
		ofType(UserActions.resetPasswordRequest),
		exhaustMap(props =>
			this.usersService.passwordRequestResetPost(props.payload).pipe(
				tap(() => this.router.navigate(['/'])),
				map(() => MessageActions.displayError({ code: 'STATUS_PASSWORD_RESET' })),
				catchError(() => of(MessageActions.displayError({ code: 'ERROR_PASSWORD_RESET_FAILED' })))
			)
		)
	));

	deleteAccountConfirmation$ = createEffect(() => this.actions$.pipe(
		ofType(UserActions.deleteAccountConfirmation),
		exhaustMap(() => this.dialogService.runDialog(DeleteAccountConfirmationComponent).pipe(
			map(() => UserApiActions.deleteAccount()),
			catchError(() => of(UserActions.logoutConfirmationDismiss()))
		))
	));

	deleteAccount$ = createEffect(() => this.actions$.pipe(
		ofType(UserApiActions.deleteAccount),
		switchMap(() =>
			this.usersService.profileDeletePost().pipe(
				tap(() => this.router.navigate(['/'])),
				map(() => UserApiActions.deleteAccountSuccess()),
				catchError(error => of(UserApiActions.deleteAccountFailure({ error })))
			),
		)
	));

	deleteAccountSuccess$ = createEffect(() => this.actions$.pipe(
		ofType(UserApiActions.deleteAccountSuccess),
		map(() => MessageActions.displayError({ code: 'STATUS_ACCOUNT_DELETION_SUCCESS' })),
	));

	deleteAccountFailure$ = createEffect(() => this.actions$.pipe(
		ofType(UserApiActions.deleteAccountFailure),
		map(() => MessageActions.displayError({ code: 'ERROR_ACCOUNT_DELETION_FAILED' })),
	));

	constructor(
		private actions$: Actions,
		private usersService: UsersService,
		private router: Router,
		private authStore: Store<fromAuth.State>,
		private dialogService: ModalDialogService,
	) {}
}
