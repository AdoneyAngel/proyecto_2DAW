import { Component } from '@angular/core';
import { AppComponent } from '../../app.component';
import { DashboardComponent } from '../dashboard/dashboard.component';
import { FormsModule } from '@angular/forms';
import { createProject } from '../../../API/api';
import { Router } from '@angular/router';

@Component({
  selector: 'app-create-project',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './create-project.component.html',
  styleUrl: './create-project.component.css'
})
export class CreateProjectComponent {
  title:string = ""

  constructor (private app:AppComponent, private dashboard:DashboardComponent, private router:Router){}

  ngOnInit() {
    this.dashboard.setTitle("Create new project")
  }

  async createProject() {
    //Check title
    if (!this.title.length) {
      this.app.notificationError("Title is required")
    }

    try {
      const res = await createProject(this.title)

      if (res.success) {
        this.app.notificationSuccess("Project created")

        this.router.navigate([`/dashboard/projects/${res.data.id}`])

      } else {
        this.app.notificationError(res.error ?? "Something gone wrong")
      }

    } catch (err) {
      this.app.notificationError("Something gone wrong")
    }
  }
}
