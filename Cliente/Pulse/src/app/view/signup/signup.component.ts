import { Component } from '@angular/core';
import { FormsModule } from "@angular/forms"
import { signup } from '../../../API/api';
import { AppComponent } from '../../app.component';

@Component({
  selector: 'app-signup',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './signup.component.html',
  styleUrl: './signup.component.css'
})
export class SignupComponent {
  constructor (private appComponent: AppComponent) {}

  person = {
    username: "",
    email: "",
    password: ""
  }
  isLoading:boolean = false

  async submit(e: Event): Promise<void|boolean> {
    e.preventDefault();

    if (!this.validateForm()) {return false}

    this.isLoading = true

    const res = await signup(this.person.username, this.person.email, this.person.password)

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
