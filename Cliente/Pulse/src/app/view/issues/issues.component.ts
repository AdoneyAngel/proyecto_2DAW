import { Component } from '@angular/core';
import { AppComponent } from '../../app.component';
import { DashboardComponent } from '../dashboard/dashboard.component';
import { getIncludedProjects } from '../../../API/api';

@Component({
  selector: 'app-issues',
  standalone: true,
  imports: [],
  templateUrl: './issues.component.html',
  styleUrl: './issues.component.css'
})
export class IssuesComponent {
  projects:any = []

  constructor(private app:AppComponent, private dashboard:DashboardComponent){}

  ngOnInit() {
    this.loadProjects()
  }

  loadProjects() {
    getIncludedProjects(false, false, false, true)
    .then(res => {
      if (res.success) {
        this.projects = res.data

      } else {
        this.app.notificationError(res.error??'Something gone wrong getting the issues, try again later')
      }
    })
  }
}
