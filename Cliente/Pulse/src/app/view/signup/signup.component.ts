import { Component } from '@angular/core';
import { FormsModule } from "@angular/forms"
import { googleSignUp, signup } from '../../../API/api';
import { AppComponent } from '../../app.component';
import { environment } from '../../../environments/environment';
import { NgIf } from '@angular/common';

declare const google:any;

@Component({
  selector: 'app-signup',
  standalone: true,
  imports: [FormsModule, NgIf],
  templateUrl: './signup.component.html',
  styleUrl: './signup.component.css'
})
export class SignupComponent {
  person = {
    username: "",
    email: "",
    password: ""
  }
  isLoading:boolean = false
  googleLogin:boolean = false
  googleCredential:string|null = null

  constructor (private appComponent: AppComponent) {}

  ngOnInit() {
    this.renderGoogleLoginButton()
  }

  googleSignUp(googleResponse:any) {
    this.googleCredential = googleResponse.credential
  }

  async renderGoogleLoginButton() {
    this.loadGoogleScript()
    .then(() => {
      google.accounts.id.initialize({
        client_id: environment.GOOGLE_CLIENT_ID,
        callback: this.googleSignUp.bind(this),
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

  async submit(e: Event): Promise<void|boolean> {
    e.preventDefault();

    if (!this.validateForm()) {return false}

    this.isLoading = true

    let res = null

    if (this.googleCredential) {
      res = await googleSignUp(this.person.username, this.person.email, this.googleCredential)

    } else {
      res = await signup(this.person.username, this.person.email, this.person.password)

    }

    this.isLoading = false

    if (!res.success) {
      this.showError(res.error)
    }

  }

  validateForm(): boolean {
    if (!this.person.username.length) {
      this.showError("Your username is necessary")

      return false
    }
    if (!this.person.email.length) {
      this.showError("You have to write your email")

      return false
    }
    if (!this.person.email.includes("@")) {
      this.showError("The email is invalid")

      return false
    }
    if (!this.person.password.length && (!this.googleCredential || !this.googleCredential.length)) {
      this.showError("The password is necessary for you security")

      return false
    }

    return true
  }

  showError(message:string) {
    this.appComponent.notificationError(message)
  }
}
