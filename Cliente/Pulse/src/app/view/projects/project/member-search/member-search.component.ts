import { Component, Input } from '@angular/core';
import { PopupBackgroundComponent } from '../../../../components/popup-background/popup-background.component';
import { LoadingComponent } from '../../../../components/loading/loading.component';
import { addUserToProyect, searchUser } from '../../../../../API/api';
import { FormsModule } from '@angular/forms';
import { AppComponent } from '../../../../app.component';
import { ProfileImageComponent } from "../../../../components/profile-image/profile-image.component";
import { NgIf } from '@angular/common';

@Component({
  selector: 'app-member-search',
  standalone: true,
  imports: [PopupBackgroundComponent, LoadingComponent, FormsModule, ProfileImageComponent, ProfileImageComponent, NgIf],
  templateUrl: './member-search.component.html',
  styleUrl: './member-search.component.css'
})
export class MemberSearchComponent {
  @Input() close:VoidFunction = ()=>{}
  @Input() project:any = {}
  searchMember:boolean = false
  searchUser:boolean = false
  userData:string = ""
  memberData:string = ""
  filteredMembers:any = []
  filteredUsers:any = []
  isLoading:boolean = false
  searchTimeout:any = null
  usersString:string = ""

  constructor (protected app:AppComponent){}

  setSearchTimeout() {
    clearTimeout(this.searchTimeout)

    this.searchTimeout = setTimeout(() => {
      this.searchUsers()
    }, 1000)
  }

  async searchUsers() {
    this.isLoading = true

    searchUser(this.usersString)
    .then(res => {
      if (res.success) {
        this.filteredUsers = res.data

      } else {
        this.app.notificationError(res.error)
      }

    })
    .finally(() => {
      this.isLoading = false
    })
  }

  onKeyUpUser(event:any) {
    const input = event.target
    const value = input.value

    if (!value.length) {
      clearTimeout(this.searchTimeout)
      this.searchUser = false
      this.filteredUsers = []

    } else {
      this.searchUser = true
      this.setSearchTimeout()
    }
  }

  onKeyUpMember(event:any) {
    const input = event.target
    const value = input.value

    if (!value.length) {
      this.searchMember = false

    } else {
      this.searchMember = true

      this.filteredMembers = this.project.members.filter((member:any) => member.username.includes(value) || member.email.includes(value))
    }
  }

  async sendInvitation(userId:string|number):Promise<any> {
    if (!(userId+"").length) return null

    addUserToProyect(this.project.id, userId)
    .then(res => {
      if (res.success) {
        this.app.notificationSuccess("Invitación enviada")

      } else {
        this.app.notificationError(res.error)
      }
    })
  }

  isJoined(userId:string|number):boolean {
    let joined = false

    this.project?.members?.forEach((member:any) => {
      if (member.id == userId) {
        joined = true
      }
    })

    return joined
  }
}
