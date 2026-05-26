import { Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { ListComponent } from './components/list/list.component';
import { DetailsComponent } from './components/details/details';
import { EditFormComponent } from './components/edit-form/edit-form.component';

export const routes: Routes = [
 { path: '', component: ListComponent },
{ path: 'login', component: LoginComponent },
{ path: 'details/:id', component: DetailsComponent },
{ path: 'add', component: EditFormComponent },
{ path: 'edit/:id', component: EditFormComponent }

];