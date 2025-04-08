import { Component, ElementRef, ViewChild } from '@angular/core';
import { addGoogleAccount, checkGoogleAccount, checkUserPassword, getUser, removeGoogleAccount, updateUser, uploadProfilePhoto } from '../../../API/api';
import { AppComponent } from '../../app.component';
import { MainContentBoxComponent } from '../../components/main-content-box/main-content-box.component';
import { ProfileImageComponent } from '../../components/profile-image/profile-image.component';
import { DashboardComponent } from '../dashboard/dashboard.component';
import { FormsModule } from '@angular/forms';
import { NgIf } from '@angular/common';
import { environment } from '../../../environments/environment';
import { Router } from '@angular/router';

declare const google: any;

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
  environment:any = {}
  haveGoogleAccount:boolean = false
  googleAccountChecked:boolean = false

  constructor(private app:AppComponent, private dashboard:DashboardComponent, private router:Router) {
    this.environment = environment
  }

  ngOnInit() {
    this.checkGoogleAccount()
    this.loadProfile()

    this.loadGoogleScript().then(() => {
      google.accounts.id.initialize({
        client_id: environment.GOOGLE_CLIENT_ID,
        callback: this.onGoogleLogin.bind(this),
      });

      google.accounts.id.renderButton(
        document.getElementById('googleButton'),
        {
          'theme': '',
          'scope': 'profile email',
          'width': 240,
          'height': 50,
          'longtitle': true
        });
    });
  }

  askFormProfileImage() {
    console.log(this.imageFileDom.nativeElement.click())
  }

  async onGoogleLogin(response: any) {
    const token = response.credential
    this.googleAccountChecked = false

    addGoogleAccount(token)
    .then(res => {
      if (res.success) {
        this.app.notificationSuccess("Account synchronized")

      } else {
        this.app.notificationError(res.error)
      }

    })
    .finally(this.checkGoogleAccount.bind(this))
  }

  loadGoogleScript(): Promise<void> {
    return new Promise((resolve) => {
      const script = document.createElement('script');
      script.src = 'https://accounts.google.com/gsi/client';
      script.async = true;
      script.defer = true;
      script.onload = () => resolve();
      document.body.appendChild(script);
    });
  }

  async checkGoogleAccount() {
    this.googleAccountChecked = false

    try {
      const res = await checkGoogleAccount()

      if (res.success) {
        this.haveGoogleAccount = res.data

        this.googleAccountChecked = true

      } else {
        this.app.notificationError(res.error)
      }

    } catch (err) {
      this.app.notificationError("Something gone wrong checking Google Account")

    }
  }

  askRemoveGoogleAccount() {
    this.app.showAccept("Are you sure you want to unsync your Google Account?", this.removeGoogleAccount.bind(this))
  }

  async removeGoogleAccount() {
    this.app.hideAccept()

    try {
      //Check if the user have password
      const resCheckPassword = await checkUserPassword()
      let userHavePassword = false

      if (resCheckPassword.success) {
        userHavePassword = resCheckPassword.data
      }

      if (userHavePassword) {
        removeGoogleAccount()
        .then(res => {
          if (res.success) {
            this.app.notificationSuccess("Google Account removed")

            this.checkGoogleAccount()

          } else {
            this.app.notificationError(res.error)
          }
        })

      } else {
        this.app.notificationError("You have to create a password")
        this.router.navigate(["/addPassword"])
      }

    } catch (err) {
      this.app.notificationError("Something gone wrong")

    }
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
