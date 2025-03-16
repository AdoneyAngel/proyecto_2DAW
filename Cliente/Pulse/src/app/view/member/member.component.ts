import { Component } from '@angular/core';
import { ActivatedRoute, Params, RouterLink } from '@angular/router';
import { getMember, getProject, getTaskOfProject, updateMember } from '../../../API/api';
import { ProjectComponent } from '../projects/project/project.component';
import { AppComponent } from '../../app.component';
import { DashboardComponent } from '../dashboard/dashboard.component';
import { ProfileImageComponent } from '../../components/profile-image/profile-image.component';
import { MainContentBoxComponent } from '../../components/main-content-box/main-content-box.component';
import { ContentBoxSimpleDelimiterComponent } from '../../components/content-box-simple-delimiter/content-box-simple-delimiter.component';
import UserTaskStatusEnum from '../../enums/UserTaskStatusEnum';
import { TextLinkComponent } from '../../components/text-link/text-link.component';
import { NgIf } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-member',
  standalone: true,
  imports: [ProfileImageComponent, MainContentBoxComponent, ContentBoxSimpleDelimiterComponent, TextLinkComponent, RouterLink, NgIf, FormsModule],
  templateUrl: './member.component.html',
  styleUrl: './member.component.css'
})
export class MemberComponent {
  memberId:string|number|null = null
  projectId:string|number|null = null
  member:any = null
  project:any = null
  tasks:any = []
  editing:boolean = false
  newEffectiveTime:number = 1
  userTaskStatus:any = {
    Todo: null,
    Progress: null,
    Done: null
  }

  constructor (private activatedRoute:ActivatedRoute, private projectComponent:ProjectComponent, private app:AppComponent, private dashboard:DashboardComponent){
    this.userTaskStatus.Todo = UserTaskStatusEnum.Todo
    this.userTaskStatus.Progress = UserTaskStatusEnum.Progress
    this.userTaskStatus.Done = UserTaskStatusEnum.Done
  }

  ngOnInit() {
    this.loadParams()
  }

  ngOnDestroy() {
    this.projectComponent.setOnMain(true)
  }

  ngDoCheck() {
    this.projectComponent.setOnMain(false)
  }

  loadParams() {
      this.activatedRoute.params.subscribe(
        (params:Params) => {
          this.memberId = params["memberId"]
          this.projectId = this.projectComponent.getProjectId()

          this.loadMember()
          this.loadProject()
        }
      )
  }

  async loadMember():Promise<any> {
    if (!this.memberId) return null
    if (!this.projectId) return null

    getMember(this.projectId, this.memberId)
    .then(res => {
      if (res.success) {
        this.member = res.data
        this.newEffectiveTime = res.data.effectiveTime

        this.dashboard.setRouteCustomTitle("member", res.data.username)
        this.dashboard.setTitle(res.data.username)

        //load photo of member
        this.dashboard.findUserPhoto(res.data.id)
        .then(photoUrl => {
          this.member.photoUrl = photoUrl.photo
        })


      } else {
        this.app.notificationError(res.error)
      }
    })

  }

  async loadProject():Promise<any> {
    if (!this.memberId) return null
    if (!this.projectId) return null

    getProject(this.projectId)
    .then(res => {
      if (res.success) {
        this.project = res.data

        this.loadTasks()

      } else {
        this.app.notificationError(res.error)
      }
    })

  }

  async loadTasks():Promise<any> {
    if (!this.projectId) return null
    if (!this.memberId) return null

    getTaskOfProject(this.projectId, false, true)
    .then(res => {
      if (res.success) {
        let tasks = res.data.filter((actualTask:any) => actualTask.users?.find((actualUser:any) => actualUser.id == this.memberId)??false)

        tasks.forEach((actualTask:any) => {
          const userOnTask = actualTask.users.find((actualUser:any) => actualUser.id == this.memberId)

          actualTask.userStatus = userOnTask.taskStatus
        })

        this.tasks = tasks

      } else {
        this.app.notificationError(res.error??"The load of tasks was failed")
      }
    })
  }

  setEditing() {
    this.editing = true
  }
  unSetEditing() {
    this.editing = false
  }

  async saveEffectiveTime():Promise<any> {
    if (!this.memberId) return null
    if (!this.projectId) return null

    if (this.newEffectiveTime < 1) {
      this.app.notificationError("Invalid effective time")
      return null
    }

    updateMember(this.projectId, this.memberId, {
      effectiveTime: this.newEffectiveTime
    })
    .then(res => {
      if (res.success) {
        this.app.notificationSuccess("Effective time updated")
        this.unSetEditing()

      } else {
        this.app.notificationError(res.error??'Some things gone wrong updating the member')
      }
    })

  }
}
