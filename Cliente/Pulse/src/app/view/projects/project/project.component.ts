import { Component } from '@angular/core';
import { ActivatedRoute, Params, Router, RouterLink, RouterOutlet } from '@angular/router';
import { getProject, getProyectMemberType, getTaskOfProject, updateProjectTitle } from '../../../../API/api';
import { AppComponent } from '../../../app.component';
import { DashboardComponent } from '../../dashboard/dashboard.component';
import { Title } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { MainContentBoxComponent } from '../../../components/main-content-box/main-content-box.component';
import { ProfileImageComponent } from '../../../components/profile-image/profile-image.component';
import TaskStatusEnum from '../../../enums/TaskStatusEnmu';
import { TaskComponent } from './task/task.component';
import { ContentBoxDelimiterComponent } from '../../../components/content-box-delimiter/content-box-delimiter.component';
import { NgIf } from '@angular/common';
import { MemberSearchComponent } from './member-search/member-search.component';
import MemberTypeEnum from '../../../enums/MemberTypeEnum';

@Component({
  selector: 'app-project',
  standalone: true,
  imports: [FormsModule, MainContentBoxComponent, ProfileImageComponent, TaskComponent, ContentBoxDelimiterComponent, RouterLink, RouterOutlet, NgIf, MemberSearchComponent],
  templateUrl: './project.component.html',
  styleUrl: './project.component.css'
})
export class ProjectComponent {
  showMemberSearch:boolean = false
  showMemberList:boolean = false
  projectId:number|string = 0
  project:any = {}
  newProjectTitle:string = ""
  memberPhotos:any = []
  isOnMain:boolean = false
  title:string = "Project"
  isOwner:boolean = false
  memberTypeEnum:any = MemberTypeEnum
  memberType:number = 2
  tasks: any = {
    onRack: [],
    todo: [],
    progress: [],
    review: [],
    done: []
  }

  constructor (protected activedRouter:ActivatedRoute, protected app:AppComponent, protected dashboard:DashboardComponent, protected titleService:Title, protected router:Router){}

  ngOnInit() {
    this.clearPage()

    this.onRouteChanges()

    this.setOnMain(true)
  }

  openShowMemberSearch() {
    this.showMemberSearch = true
  }
  closeShowMemberSearch() {
    this.showMemberSearch = false
  }

  clearPage() {
    this.project = {}
    this.newProjectTitle = ""
    this.tasks = {
      onRack: [],
      todo: [],
      progress: [],
      review: [],
      done: []
    }
  }

  setOnMain(value:boolean) {
    this.isOnMain = value
  }

  onRouteChanges() {
    this.title = this.app.getTitle()

    // if (this.title != "project") {
    //   this.isOnMain = false

    // } else {
    //   this.isOnMain = true
    // }

    this.activedRouter.params.subscribe(
      (param: Params) => {
        if (this.projectId != param["id"] && this.isOnMain) {
          this.clearPage()
          this.projectId = param["id"]
          this.loadProject()

        } else if (this.isOnMain && !this.project.id) {
          this.clearPage()
          this.projectId = param["id"]
          this.loadProject()

        } else if (!this.isOnMain && !this.project.id) {
          this.projectId = param["id"]
          this.loadProject()
        }

      }
    )
  }

  ngAfterViewInit() {
    this.setMemberListPosition()
  }

  setMemberListPosition() {
    const projectBody = document.getElementById("projectBody")
    const memberList:any = document.getElementById("memberList")

    const dimensions:any = projectBody?.getClientRects()[0]

    memberList.style.left = ((dimensions.x-7.5+dimensions?.width/2) - (memberList.width/2)) + "px"
    memberList.style.width = dimensions.width-100 + "px"
  }

  async loadProject() {
    const res = await getProject(this.projectId, true, true)

    if (res.success) {
      this.dashboard.setTitle(".")
      this.newProjectTitle = res.data.title
      this.project = res.data

      const user = this.app.getUser()

      this.isOwner = user.id == this.project.owner.id

      //If the user is not the owner, check the type of member
      if (!this.isOwner) {
        this.loadMemberType()
      }

      //Load owner profile image
      this.dashboard.findUserPhoto(this.project.owner.id)
      .then(data => {
        this.project.owner.photoUrl = data.photo
      })

      //Ordenate the users (first the owner and then the current user)
      this.project.members = this.project.members.sort((prev:any, next:any) => {
        if (next.id == this.project.owner.id) {
          return 1

        } else if (next.id == user.id && prev.id != this.project.owner.id) {
          return 1

        } else {
          return -1
        }
      })

      this.loadMemberPhotos()
      this.loadTasks()

    } else {
      this.app.notificationError(res.error)
    }
  }

  async loadMemberType () {
    const user = this.app.getUser()

    getProyectMemberType(this.project.id, user.id)
    .then(res => {
      if (res.success) {
        this.memberType = res.data
      }
    })
  }

  getProject() {
    return this.project
  }
  getProjectId() {
    return this.projectId
  }

  async loadTasks() {
    getTaskOfProject(this.project.id, false, true)
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

    this.project.members.forEach(async (member:any) => {
      const photoFound = await this.dashboard.findUserPhoto(member.id)

      member.photoUrl = photoFound.photo
      this.memberPhotos = [...this.memberPhotos, photoFound]
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
