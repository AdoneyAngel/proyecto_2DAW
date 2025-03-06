import { Component } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { getProject, getProjectTasks, getUserPhoto, updateProjectTitle } from '../../../../API/api';
import { AppComponent } from '../../../app.component';
import { DashboardComponent } from '../../dashboard/dashboard.component';
import { Title } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { MainContentBoxComponent } from '../../../components/main-content-box/main-content-box.component';
import { ProfileImageComponent } from '../../../components/profile-image/profile-image.component';
import TaskStatusEnum from '../../../enums/TaskStatusEnmu';
import { TaskComponent } from './task/task.component';
import { ContentBoxDelimiterComponent } from '../../../components/content-box-delimiter/content-box-delimiter.component';

@Component({
  selector: 'app-project',
  standalone: true,
  imports: [FormsModule, MainContentBoxComponent, ProfileImageComponent, TaskComponent, ContentBoxDelimiterComponent],
  templateUrl: './project.component.html',
  styleUrl: './project.component.css'
})
export class ProjectComponent {
  projectId:number|string = 0
  project:any = {}
  newProjectTitle:string = ""
  memberPhotos:any = []
  tasks: any = {
    onRack: [],
    todo: [],
    progress: [],
    review: [],
    done: []
  }

  constructor (protected activedRouter:ActivatedRoute, protected app:AppComponent, protected dashboard:DashboardComponent, protected titleService:Title){}

  ngOnInit() {
    this.activedRouter.params.subscribe(
      (param: Params) => {
        this.project = {}
        this.newProjectTitle = ""
        this.tasks = {
          onRack: [],
          todo: [],
          progress: [],
          review: [],
          done: []
        }

        this.projectId = param["id"]
        this.loadProject()
      }
    )
  }

  ngAfterViewInit() {
    const projectBody = document.getElementById("projectBody")
    const memberList:any = document.getElementById("memberList")

    const dimensions:any = projectBody?.getClientRects()[0]

    memberList.style.left = (dimensions.x-7.5+dimensions?.width/2) + "px"
    memberList.style.width = dimensions.width-100 + "px"
  }

  async loadProject() {
    const res = await getProject(this.projectId, true, true)

    if (res.success) {
      this.dashboard.setTitle(".")
      this.newProjectTitle = res.data.title
      this.project = res.data
      this.dashboard.setRouteCustomTitle("project", res.data.title)

      this.loadMemberPhotos()
      this.loadTasks()

    } else {
      this.app.notificationError(res.error)
    }
  }

  async loadTasks() {
    getProjectTasks(this.project.id, true)
    .then(res => {
      if (res.success) {
        res.data.forEach((task:any) => {

          if (task.users) {
            task.users.forEach((user:any) => {
              const userPhotoFound = this.memberPhotos.find((actualPhoto:any) => actualPhoto.id == user.id)

              user.photoUrl = userPhotoFound ? userPhotoFound.photo : null
            })
          }

          if (!task.users || !task.users.length) {
            this.tasks.onRack = [...this.tasks.onRack, task]
          }
          if (task.statusId == TaskStatusEnum.Todo && task.users && task.users.length) {
            this.tasks.todo = [...this.tasks.todo, task]
          }
          if (task.statusId == TaskStatusEnum.Progress && task.users && task.users.length) {
            this.tasks.progress = [...this.tasks.progress, task]
          }
          if (task.statusId == TaskStatusEnum.Review && task.users && task.users.length) {
            this.tasks.review = [...this.tasks.review, task]
          }
          if (task.statusId == TaskStatusEnum.Done && task.users && task.users.length) {
            this.tasks.done = [...this.tasks.done, task]
          }
        })

      } else {
        this.app.notificationError(res.error)
      }
    })
  }

  async loadMemberPhotos() {
    this.memberPhotos = this.dashboard.getUsersPhotos()

    this.project.members.forEach((member:any) => {
      //Load local
      const photoFound = this.memberPhotos.find((photo:any) => photo.id==member.id)

      if (photoFound) {
        member.photoUrl = photoFound.photo

      } else {
        //Load API
        getUserPhoto(member.id)
        .then((res:any) => {
          if (res) {
            member.photoUrl = res

            this.memberPhotos = [...this.memberPhotos, {id:member.id, photo:res}]
            this.dashboard.addUserPhoto(member.id, res)

          } else {
            member.photoUrl = null
          }
        })
      }
    })
  }

  async updateTitle() {
    if (!this.newProjectTitle.length) {
      this.app.notificationError("Title is empty")
    }

    if (!this.newProjectTitle != this.project.title) {
      updateProjectTitle(this.project.id, this.newProjectTitle)
      .then(res => {
        if (res.success) {
          this.app.notificationSuccess("Title updated")
          this.project.title = this.newProjectTitle

        } else {
          this.app.notificationError(res.error)
        }
      })
    }
  }

  deploySection(contentId:string) {
    const content:any = document.getElementById(contentId)

    content.className = content.className=="opened"?"closed":"opened"
  }
}
