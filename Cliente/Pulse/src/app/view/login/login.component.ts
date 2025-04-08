import { Component } from '@angular/core';
import { FormsModule } from "@angular/forms"
import { googleLogin, login, loginEmail } from '../../../API/api';
import { AppComponent } from '../../app.component';
import { Router } from '@angular/router';
import { NgIf } from '@angular/common';
import { environment } from '../../../environments/environment';

declare const google:any;

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [FormsModule, NgIf],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  emailChecked:boolean = false
  googleAccount:boolean = false
  person = {
    email: "",
    password: ""
  }
  isLoading:boolean = false

  constructor (private appComponent: AppComponent, private router:Router) {}

  async submit(e: Event): Promise<void|boolean> {
    e.preventDefault();

    if (!this.emailChecked && this.validateFormEmail()) {//Check the email
      this.isLoading = true

      try {
        const res = await loginEmail(this.person.email)

        if (res.success) {
          if (res.data.googleAccount) {
            this.renderGoogleLoginButton()

            this.googleAccount = true

          } else {
            this.googleAccount = false
          }

          this.emailChecked = true

        } else {
          this.appComponent.notificationError(res.error)
        }

      } catch (err) {
        this.appComponent.notificationError("Something gone wrong")
        this.emailChecked = false
        this.googleAccount = false

      } finally {
        this.isLoading = false
      }

    } else if(this.emailChecked && !this.googleAccount && this.validatePasswordForm()) {//If the user dont have google account, check password
      this.isLoading = true

      try {
        const res = await login(this.person.email, this.person.password)

        this.isLoading = false

        if (!res.success) {
          this.showError(res.error)

        } else {
          this.router.navigate(["/dashboard"])
        }

      } catch (err) {
        this.appComponent.notificationError("Something gone wrong")
        this.emailChecked = false
        this.googleAccount = false

      } finally {
        this.isLoading = false
      }
    }

  }

  async googleLogin(googleResponse:any) {
    const token = googleResponse.credential

    try {
      googleLogin(token)
      .then(res => {
        if (res.success) {
          this.router.navigate(["/dashboard"])

        } else {
          this.appComponent.notificationError(res.error)
        }
      })

    } catch (err) {
      this.appComponent.notificationError("Something gone wrong")
    }

  }

  async renderGoogleLoginButton() {
    this.loadGoogleScript()
    .then(() => {
      google.accounts.id.initialize({
        client_id: environment.GOOGLE_CLIENT_ID,
        callback: this.googleLogin.bind(this),
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
    })

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

  validateFormEmail():boolean {
    if (!this.person.email.length) {
      this.showError("You have to write your email")

      return false
    }
    if (!this.person.email.includes("@")) {
      this.showError("The email is invalid")

      return false
    }

    return true
  }

  validatePasswordForm(): boolean {
    if (!this.person.password.length) {
      this.showError("The password is necessary for you security")

      return false
    }

    return true
  }

  showError(message:string) {
    this.appComponent.notificationError(message)
  }
}
