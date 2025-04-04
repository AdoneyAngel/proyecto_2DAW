import { Component } from '@angular/core';
import { MainContentBoxComponent } from '../../../components/main-content-box/main-content-box.component';
import { DashboardComponent } from '../../dashboard/dashboard.component';
import { AppComponent } from '../../../app.component';
import { createIssue, getIncludedProjects, getProject, getTags } from '../../../../API/api';
import { CreateTaskFormComponent } from '../../../components/createTask/create-task-form/create-task-form.component';
import { Router } from '@angular/router';

@Component({
  selector: 'app-create-issue',
  standalone: true,
  imports: [MainContentBoxComponent, CreateTaskFormComponent],
  templateUrl: './create-issue.component.html',
  styleUrl: './create-issue.component.css'
})
export class CreateIssueComponent {
  selectedProject:number|null = null
  selectedTask:number|null = null
  project:any|null = null
  projects:any = []
  projectTags:any = []
  isProjectOwner:boolean = false

  constructor (private dahsboard:DashboardComponent, private app:AppComponent, private router:Router) {}

  ngOnInit() {
    this.dahsboard.setTitle("Select the project")
    this.loadProjects()
  }

  async submit(title:string, description:string, tag:string, time:number, priority:number, users:any = []) {
    if (!this.validateForm(title, description, tag, time, priority, users)) {
      return false
    }

    createIssue(this.project.id, title, description, time, priority, tag, users)
    .then(res => {
      console.log(res)
      if (res.success) {
        this.app.notificationSuccess("Task Created")
        this.router.navigate(["/dashboard/issues"])

        return true

      } else {
        this.app.notificationError(res.error)
        return false
      }
    })

    return true
  }

  validateForm(title:string, description:string, tag:string, time:number, priority:number, users:any = []):boolean {
    let valid = true

    if (!title || !title.length) {
      this.app.notificationError("Title is obligatory")
      valid = false
    }
    if (time<=0) {
      this.app.notificationError("Invalid estimated time")
      valid = false
    }
    if (priority<=0) {
      this.app.notificationError("Invalid priority")
      valid = false
    }

    return valid
  }

  selectTask(taskId:number) {
    this.selectedTask = taskId
  }

  selectProject(projectId:number):any {
    try {
      if (!projectId) return null

      this.selectedProject = projectId

      this.loadProject()

    } catch (err) {
      this.app.notificationError("Something gone wrong")
    }
  }

  async loadTags(): Promise<any> {
    try {
      if (!this.project) return null

      const res = await getTags(this.project.id)

      if (!res.success) {
        this.app.notificationError(res.error)
        return null
      }

      this.projectTags = res.data

    } catch (err) {
      this.app.notification("Something gone wrong loading tags")
    }
  }

  async loadProject():Promise<any> {
    try {
      if (!this.selectedProject) return null

      const res = await getProject(this.selectedProject, true, true)

      if (!res.success) {
        this.app.notificationError(res.error)
        this.dahsboard.setTitle("Select the project")
        return null
      }

      this.project = res.data

      this.isProjectOwner = this.app.getUser().id == this.project.ownerId

      this.dahsboard.setTitle("Create issue")

      this.loadTags()

    } catch (err) {
      this.app.notificationError("Something gone wrong")
      this.dahsboard.setTitle("Select the project")
    }
  }

  async loadProjects() {
    try {
      getIncludedProjects()
      .then(res => {
        if (res.success) {
          this.projects = res.data

        } else {
          this.app.notificationError(res.error)
        }
      })

    } catch (err) {
      this.app.notificationError("Something gone wrong")
    }
  }
}
