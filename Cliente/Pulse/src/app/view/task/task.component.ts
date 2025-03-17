import { Component } from '@angular/core';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { AppComponent } from '../../app.component';
import { changeUserStatus, deleteTask, getProjectMembers, getTask, updateTask } from '../../../API/api';
import { DashboardComponent } from '../dashboard/dashboard.component';
import { MainContentBoxComponent } from '../../components/main-content-box/main-content-box.component';
import { FormsModule } from '@angular/forms';
import { NgIf } from '@angular/common';
import { ProfileImageComponent } from '../../components/profile-image/profile-image.component';
import { ContentBoxDelimiterComponent } from '../../components/content-box-delimiter/content-box-delimiter.component';
import { ProjectComponent } from '../projects/project/project.component';
import UserTaskStatusEnum from '../../enums/UserTaskStatusEnum';

@Component({
  selector: 'app-task',
  standalone: true,
  imports: [MainContentBoxComponent, FormsModule, NgIf, ProfileImageComponent, ContentBoxDelimiterComponent],
  templateUrl: './task.component.html',
  styleUrl: './task.component.css'
})
export class TaskComponent {
  taskId:number|string = 0
  task:any = {}
  isOwner:boolean = false
  newTitle:string = ""
  newDescription:string = ""
  newTag:string = ""
  newPriority:string = ""
  newTime:string = ""
  newUsers:any = []
  editing:boolean = false
  draggingUserId:number|string = 0
  isChanged:boolean = false
  newStatus:UserTaskStatusEnum|null = null
  totalEt:number = 0
  userTaskStatus:any = {
    Todo: null,
    Progress: null,
    Done: null
  }

  constructor (private activatedRoute:ActivatedRoute, protected app:AppComponent, private dashboard:DashboardComponent, private router:Router, private projectComponent:ProjectComponent){
    this.userTaskStatus.Todo = UserTaskStatusEnum.Todo
    this.userTaskStatus.Progress = UserTaskStatusEnum.Progress
    this.userTaskStatus.Done = UserTaskStatusEnum.Done
  }

  setTitle(event:any) {
    this.newTitle = event.target.value

    this.setIsChanged()
  }
  settag(event:any) {
    this.newTag = event.target.value

    this.setIsChanged()
  }
  setDescription(event:any) {
    this.newDescription = event.target.value

    this.setIsChanged()
  }
  setPriority(event:any) {
    this.newPriority = event.target.value

    this.setIsChanged()
  }
  setTime(event:any) {
    this.newTime = event.target.value

    this.setIsChanged()
  }

  ngOnInit() {
    this.loadTaskId()
  }

  ngOnDestroy() {
    this.projectComponent.setOnMain(true)
  }

  ngDoCheck() {
    this.setIsChanged()

    this.projectComponent.setOnMain(false)
  }

  setEditing() {
    if (this.editing) {
      this.resetNewValues()
    }

    this.editing = !this.editing
  }

  onDragStart(event:any, userId:number|string) {
    if (this.isOwner && this.editing) {
      event.dataTransfer.setData("text/plain", userId)

    } else {
      event.preventDefault()
    }
  }

  onDrag(event:any) {
    event.preventDefault()

    const element = event.target

    element.style.opacity = "0"
  }

  onDragEnd(event:any) {
    event.preventDefault()

    const element = event.target

    element.style.opacity = "1"

  }

  onDragOver(event:any) {
    if (this.isOwner) {
      event.preventDefault()
    }
  }

  onDropAssignedUsers(event:any) {
    event.preventDefault()

    const userId = event.dataTransfer.getData("text/plain")

    this.addUser(userId)
  }
  onDropUnassignedUsers(event:any) {
    event.preventDefault()

    const userId = event.dataTransfer.getData("text/plain")

    this.removeUser(userId)
  }

  addUser(userId:number|string) {
    this.newUsers.forEach((user:any) => {
      if (user.id == userId) {
        user.added = true
      }
    })

    this.newUsers = this.newUsers

    this.updateTotalEt()
  }
  removeUser(userId:number|string) {
    this.newUsers.forEach((user:any) => {
      if (user.id == userId) {
        user.added = false
      }
    })

    this.newUsers = this.newUsers

    this.updateTotalEt()
  }

  resetNewValues() {
    this.newTitle = this.task.title
    this.newDescription = this.task.description
    this.newTag = this.task.tag
    this.newTime = this.task.time
    this.newPriority = this.task.priority

    this.newUsers = this.newUsers.map((user:any) => {return {...user, original:this.memberIsJoined(user.id), added:this.memberIsJoined(user.id)}})

    this.updateTotalEt()
  }

  loadTaskId() {
    this.activatedRoute.params.subscribe(
      (params:Params) => {
        this.taskId = params["id"]

        this.loadTask()
      }
    )
  }

  loadTask() {
    getTask(this.taskId, true, true)
    .then(res => {
      if (res.success) {
        this.task = res.data

        if (!this.task.users) {
          this.task.users = []
        }

        this.dashboard.setTitle("")
        this.dashboard.setRouteCustomTitle("task", res.data.title)

        if (this.app.getUser().id == res.data.proyect.ownerId) {
          this.isOwner = true
        }

        this.newDescription = res.data.description
        this.newTitle = res.data.title
        this.newTag = res.data.tag
        this.newPriority = res.data.priority
        this.newTime = res.data.time

        this.loadMembers()

      } else {
        this.app.notificationError(res.error)
      }
    })
  }

  async loadMembers() {
    getProjectMembers(this.task.proyectId)
    .then(res => {
      if (res.success) {

        res.data.forEach((user:any) => {
          this.newUsers = [...this.newUsers, {...user, original:this.memberIsJoined(user.id), added:this.memberIsJoined(user.id)}]
        })

        this.updateTotalEt()

        this.loadUserPhotos()

      } else {
        this.app.notificationError(res.error)
      }
    })
  }

  updateTotalEt() {
    let total = 0

    this.newUsers.forEach((actualUser:any) => {
      if (actualUser.added) {
        total += actualUser.effectiveTime
      }
    })

    this.totalEt = total
  }

  memberIsJoined(memberId:number|string):boolean {
    let joined = false
    this.task?.users?.forEach((user:any) => {
      if (user.id == memberId) {
        joined = true
      }
    })

    return joined
  }

  async loadUserPhotos() {
    this.newUsers.forEach(async (user:any) => {
      const photoFound = await this.dashboard.findUserPhoto(user.id)

      user.photoUrl = photoFound.photo
    })
  }

  async submit() {
    if (this.validateForm()) {
      const usersId = this.newUsers.filter((user:any) => user.added).map((user:any) => user.id)

      const res = await updateTask(this.taskId, this.newTitle, this.newDescription, Number(this.newTime), Number(this.newPriority), this.newTag, usersId)

      if (res.success) {
        this.app.notificationSuccess("Task updated")
        window.location.href = "/dashboard/projects/"+this.task.proyectId

      } else {
        this.app.notificationError(res.error)
      }
    }

  }

  validateForm():boolean {
    this.newTitle = this.newTitle.trim()
    this.newDescription = this.newDescription?.trim()
    this.newTag = this.newTag.trim()

    if (!this.isOwner) {
      this.app.notificationError("You can't update this task")
      return false
    }
    if (!this.newTitle || !this.newTitle.length) {
      this.app.notificationError("Missing title")
      return false
    }
    if (!this.newPriority || !Number(this.newPriority) || Number(this.newPriority) <= 0) {
      this.app.notificationError("Invalid priority number")
      return false
    }
    if (!this.newTime || !Number(this.newTime) || Number(this.newTime) <= 0) {
      this.app.notificationError("Invalid time number")
      return false
    }

    return true
  }

  setIsChanged() {
    this.isChanged = false

    if (this.newTitle != this.task.title || this.newDescription != this.task.description || this.newTag!=this.task.tag || this.newPriority!=this.task.priority || this.newTime!=this.task.time) {
      this.isChanged = true
    }

    this.newUsers?.forEach((user:any) => {
      if (user.added != user.original) {
        this.isChanged = true
      }
    })
  }

  getActualMember():any {
    const realUser = this.app.getUser()

    let member = null

    this.task?.users.forEach((actualUser:any) => {
      if (actualUser.id == realUser.id) {
        member = actualUser
      }
    })

    return member
  }

  setNewStatus(newStatus:UserTaskStatusEnum) {
    this.newStatus = newStatus
  }
  unSetNewStatus() {
    this.newStatus = null
  }

  changeStatus() {
    if (this.newStatus) {
      changeUserStatus(this.task.id, this.app.getUser().id, this.newStatus)
      .then(res => {

        if (res.success) {
          this.app.notificationSuccess("Status updated")

          //Update user status in local
          this.task.users.forEach((actualUser:any) => {
            if (actualUser.id == this.app.getUser().id) {
              actualUser.taskStatus = this.newStatus

              this.unSetNewStatus()
            }
          })

        } else {
          this.app.notificationError(res.error)
        }

      })
      .finally (() => this.app.hideAccept())

    }

  }

  askDeleteTask() {
    this.app.showAccept("Are you sure you want to delete the task?", this.deleteTask.bind(this))
  }

  async deleteTask():Promise<any> {
    if (!this.taskId) return null

    deleteTask(this.taskId)
    .then(res => {
      if (res.success) {
        this.app.notificationSuccess("Task deleted")
        window.location.href = "/dashboard/projects/"+this.projectComponent.getProjectId()

      } else {
        this.app.notificationError(res.error??'Something gone wrong, try again later')
      }
    })
  }

}
