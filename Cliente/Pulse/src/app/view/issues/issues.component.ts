import { Component } from '@angular/core';
import { AppComponent } from '../../app.component';
import { DashboardComponent } from '../dashboard/dashboard.component';
import { getIncludedProjects } from '../../../API/api';
import { MainContentBoxComponent } from '../../components/main-content-box/main-content-box.component';
import { RouterLink } from '@angular/router';
import { ProfileImageComponent } from '../../components/profile-image/profile-image.component';
import UserTaskStatusEnum from '../../enums/UserTaskStatusEnum';
import TaskStatusEnum from '../../enums/TaskStatusEnmu';

@Component({
  selector: 'app-issues',
  standalone: true,
  imports: [MainContentBoxComponent, RouterLink, ProfileImageComponent],
  templateUrl: './issues.component.html',
  styleUrls: ["../../../styles/dashboardItem.css", './issues.component.css' ]
})
export class IssuesComponent {
  projects:any = []
  userTaskStatus:any = {
    Todo:null,
    Progress:null,
    Done:null
  }
  taskStatus:any = {
    Todo:null,
    Progress:null,
    Review:null,
    Done:null
  }

  constructor(private app:AppComponent, protected dashboard:DashboardComponent){
    this.userTaskStatus.Todo = UserTaskStatusEnum.Todo
    this.userTaskStatus.Progress = UserTaskStatusEnum.Progress
    this.userTaskStatus.Done = UserTaskStatusEnum.Done

    this.taskStatus.Todo = TaskStatusEnum.Todo
    this.taskStatus.Progress = TaskStatusEnum.Progress
    this.taskStatus.Review = TaskStatusEnum.Review
    this.taskStatus.Done = TaskStatusEnum.Done
  }

  ngOnInit() {
    this.loadProjects()
  }

  loadProjects() {
    getIncludedProjects(false, false, false, true, true)
    .then(res => {
      if (res.success) {
        this.projects = res.data

        this.loadUserPhotos()

      } else {
        this.app.notificationError(res.error??'Something gone wrong getting the issues, try again later')
      }
    })
  }

  async loadUserPhotos() {
    this.projects.forEach((actualProject:any) => {

      actualProject.issues?.forEach((actualIssue:any) => {

        actualIssue.users?.forEach((actualUser:any) => {
          actualUser.photoUrl = true

          this.dashboard.findUserPhoto(actualUser.id)
          .then(res => {
            actualUser.photoUrl = res.photo
          })
        })

      })
    })
  }
}
