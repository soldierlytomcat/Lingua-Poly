import { marker as _ } from '@biesbjerg/ngx-translate-extract-marker';
import { ProfileComponent } from './components/profile/profile.component';
import { ChangePasswordComponent } from './components/change-password/change-password.component';

export const userRoutes = [
	{
		path: 'profile',
		component: ProfileComponent,
		data: { title: _('Profile') }
	},
	{
		path: 'change-password',
		component: ChangePasswordComponent,
		data: { title: _('Change Password') }
	},
];
