import { Component, ElementRef, ViewChild } from '@angular/core';
import { getUser, updateUser, uploadProfilePhoto } from '../../../API/api';
import { AppComponent } from '../../app.component';
import { MainContentBoxComponent } from '../../components/main-content-box/main-content-box.component';
import { ProfileImageComponent } from '../../components/profile-image/profile-image.component';
import { DashboardComponent } from '../dashboard/dashboard.component';
import { FormsModule } from '@angular/forms';
import { NgIf } from '@angular/common';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [MainContentBoxComponent, ProfileImageComponent, FormsModule, NgIf],
  templateUrl: './profile.component.html',
  styleUrl: './profile.component.css'
})
export class ProfileComponent {
  @ViewChild('imageFile') imageFileDom!: ElementRef;
  profile:any = {}
  editing:boolean = false
  newUsername:string = ""
  newEmail:string = ""

  constructor(private app:AppComponent, private dashboard:DashboardComponent) {}

  ngOnInit() {
    this.loadProfile()
  }

  askFormProfileImage() {
    console.log(this.imageFileDom.nativeElement.click())
  }

  async uploadImage(event:any) {
    try {
      const element = event.target

      if (element && element.files.length == 1) {
        const formData = new FormData()
        const file = element.files[0]

        formData.append("photo", file)

        const res = await uploadProfilePhoto(formData)

        if (res.success) {
          this.app.notificationSuccess("Photo updated")

          const urlImage = URL.createObjectURL(file)

          this.profile.photoUrl = urlImage

        } else {
          this.app.notificationError(res.error)
        }

      }

    } catch (err) {
      this.app.notificationError("Something gone wrong")
    }
  }

  async loadProfile() {
    try {
      getUser(0)
      .then(res => {
        if (res.success) {
          this.profile = res.data
          this.newEmail = res.data.email
          this.newUsername = res.data.username

          this.loadPhoto()

        } else {
          this.app.notificationError(res.error)
        }
      })

    } catch (err) {
      this.app.notificationError("Something gone wrong")
    }
  }

  async updateProfile():Promise<any> {
    try {
      if (!this.newEmail.length) {
        this.app.notificationError("The email shouldn't be empty")

        return null
      }

      if (!this.newUsername.length) {
        this.app.notificationError("The username shouldn't be empty")

        return null
      }

      const res = await updateUser(this.newUsername, this.newEmail)

      this.editing = false

      if (!res.success) {
        this.app.notificationError(res.error)

      } else {
        this.app.notificationSuccess("Profile updated")

        this.profile.username = this.newUsername
        this.profile.email = this.newEmail
      }

    } catch (err) {
      this.app.notificationError("Something gone wrong")
    }
  }

  async loadPhoto() {
    const res = await this.dashboard.findUserPhoto(this.profile.id)

    this.profile.photoUrl = res.photo
  }
}
