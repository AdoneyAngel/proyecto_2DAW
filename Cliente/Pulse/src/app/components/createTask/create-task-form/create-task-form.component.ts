import { Component, Input } from '@angular/core';
import { MainContentBoxComponent } from '../../main-content-box/main-content-box.component';
import { FormsModule } from '@angular/forms';
import { ProfileImageComponent } from '../../profile-image/profile-image.component';
import { NgIf } from '@angular/common';
import { AppComponent } from '../../../app.component';
import MemberTypeEnum from '../../../enums/MemberTypeEnum';

@Component({
  selector: 'app-create-task-form',
  standalone: true,
  imports: [MainContentBoxComponent, FormsModule, ProfileImageComponent, NgIf],
  templateUrl: './create-task-form.component.html',
  styleUrl: './create-task-form.component.css'
})
export class CreateTaskFormComponent {
  title:string = ""
  description:string = ""
  tag:string = ""
  priority:string = ""
  time:string = ""
  searchUser:string = ""
  filteredUsers:any = []
  users:any = []
  @Input() submit:VoidFunction|any = (title:string, description:string, tag:string, time:number, priority:number, users:any = [])=>{}
  @Input() tags:any = []
  @Input() members:any = []
  @Input() memberPhotos:any = []
  @Input() isOwner:boolean = false
  @Input() memberType:number = 2
  memberTypeEnum:any = MemberTypeEnum

  constructor (protected app:AppComponent) {}

  selectUser(userId:number|string) {
    const userIndexFound = this.users.findIndex((user:number|string) => user==userId)

    if (userIndexFound >= 0) {
      this.users = this.users.filter((user:number|string) => user != userId)
      this.members.forEach((member:any) => {
        if (member.id==userId) {
          member.selected = false
        }
      })

    } else {
      this.users = [...this.users, userId]
      this.members.forEach((member:any) => {
        if (member.id==userId) {
          member.selected = true
        }
      })
    }
  }

  filterUsers() {
    if (!this.searchUser.length) {
      this.filteredUsers = this.members

    } else {
      const filteredUsers = this.members.filter((user:any) => {
        if (user.username.toLowerCase().includes(this.searchUser.toLowerCase())) {
          return true

        } else if (user.email.toLowerCase().includes(this.searchUser.toLowerCase())) {
          return true

        }
        return false
      })

      this.filteredUsers = filteredUsers
    }
  }
}
