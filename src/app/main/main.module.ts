import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { CoreModule } from '../core/core.module';
import { mainRoutes }  from './main.routes';
import { StartComponent } from './components/start/start.component';
import { LegalDisclosureComponent } from './components/legal-disclosure/legal-disclosure.component';

@NgModule({
  imports: [
    CommonModule,
    RouterModule.forChild(mainRoutes),
    CoreModule
  ],
  declarations: [StartComponent, LegalDisclosureComponent]
})
export class MainModule { }
