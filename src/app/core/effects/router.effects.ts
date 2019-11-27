import { Injectable } from '@angular/core';
import { createEffect } from '@ngrx/effects';
import { Router, ActivatedRoute, NavigationEnd } from '@angular/router';
import { Title } from '@angular/platform-browser';
import { filter, map, mergeMap, tap } from 'rxjs/operators';
import { TranslateService } from '@ngx-translate/core';

@Injectable()
export class RouterEffects {
	updateTitle$ = createEffect(
		() => this.router.events.pipe(
			filter(event => event instanceof NavigationEnd),
			map(() => {
				let route = this.activatedRoute;
				while (route.firstChild) route = route.firstChild;
				return route;
			}),
			mergeMap(route => route.data),
			// FIXME! We have to get that from somewhere else.
			map(data => 'LinguaPoly - ' + this.translate.instant(data.title)),
			tap(title => this.titleService.setTitle(title))
		),
	{ dispatch: false });

	constructor(
		private router: Router,
		private titleService: Title,
		private activatedRoute: ActivatedRoute,
		private translate: TranslateService
	) {}
}