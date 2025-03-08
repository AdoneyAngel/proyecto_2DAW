import { Component } from '@angular/core';
import { CreateTaskFormComponent } from '../../../../components/createTask/create-task-form/create-task-form.component';
import { ActivatedRoute, Router } from '@angular/router';
import { createTask, getProject, getTags } from '../../../../../API/api';
import { AppComponent } from '../../../../app.component';
import { DashboardComponent } from '../../../dashboard/dashboard.component';
import { ProjectComponent } from '../project.component';

@Component({
  selector: 'app-create-task',
  standalone: true,
  imports: [CreateTaskFormComponent],
  templateUrl: './create-task.component.html',
  styleUrl: './create-task.component.css'
})
export class CreateTaskComponent {
  projectId:string|number = 0
  project:any = {}
  tags:any = []
  memberPhotos:any = []

  constructor (private activedRouter:ActivatedRoute, protected app:AppComponent, protected dashboard:DashboardComponent, private router:Router, private projectComponent:ProjectComponent){}

  ngOnInit() {
    this.projectId = this.projectComponent.getProjectId()

    this.projectComponent.setOnMain(false)

    this.loadProject()
  }

  ngOnDestroy() {
    this.projectComponent.setOnMain(true)
  }

  async submit(title:string, description:string, tag:string, time:number, priority:number, users:any = []) {
    if (!this.validateForm(title, description, tag, time, priority, users)) {
      return false
    }

    createTask(this.projectId, title, description, time, priority, tag, users)
    .then(res => {
      console.log(res)
      if (res.success) {
        this.app.notificationSuccess("Task Created")
        this.router.navigate(["/dashboard/projects/"+this.projectId])

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

  async loadMemberPhotos() {
    //Local
    for (let user of this.project.members) {
      this.dashboard.findUserPhoto(user.id)
      .then((photoUrl:any) => {
        user.photoUrl = photoUrl ? photoUrl.photo : null
      })
    }
  }

  async loadTags() {
    getTags(this.projectId)
    .then(res => {
      if (res.success) {
        this.tags = res.data

      } else {
        this.app.notificationError(res.error);
      }
    })
  }

  async loadProject() {
    getProject(this.projectId, true)
    .then(res => {
      if (res.success) {
        this.project = res.data

        this.dashboard.setTitle("create task")
        this.dashboard.setRouteCustomTitle("project", this.project.title)

        this.loadTags()
        this.loadMemberPhotos()

      } else {
        this.app.notificationError(res.error)
      }
    })
  }

}
