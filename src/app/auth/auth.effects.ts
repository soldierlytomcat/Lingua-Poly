import { Injectable } from '@angular/core';
import { createEffect, Actions, ofType } from '@ngrx/effects';
import { exhaustMap, map, catchError, tap } from 'rxjs/operators';
import { UsersService } from '../core/openapi/lingua-poly';
import { of } from 'rxjs';
import { LoginPageActions, AuthApiActions } from './actions';
import { Router } from '@angular/router';

@Injectable()
export class AuthEffects {
	login$ = createEffect(() => this.actions$.pipe(
		ofType(LoginPageActions.login),
		map(action => action.credentials),
		exhaustMap((userLogin) =>
			this.usersService.userLogin(userLogin).pipe(
				map(user => AuthApiActions.loginSuccess({ user })),
				catchError(error => of(AuthApiActions.loginFailure({ error })))
			)
		)
	));

	loginSuccess$ = createEffect(() => this.actions$.pipe(
		ofType(AuthApiActions.loginSuccess),
		tap(() => this.router.navigate(['/']))
	), { dispatch: false });

	constructor(
		private actions$: Actions,
		private usersService: UsersService,
		private router: Router
	) { }
}
