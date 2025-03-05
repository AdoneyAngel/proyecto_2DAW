import { Component } from '@angular/core';
import { FormsModule } from "@angular/forms"
import { login } from '../../../API/api';
import { AppComponent } from '../../app.component';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  constructor (private appComponent: AppComponent, private router:Router) {}

  person = {
    email: "",
    password: ""
  }
  isLoading:boolean = false

  async submit(e: Event): Promise<void|boolean> {
    e.preventDefault();

    if (!this.validateForm()) {return false}

    this.isLoading = true
    const res = await login(this.person.email, this.person.password)
    this.isLoading = false

    if (!res.success) {
      this.showError(res.error)

    } else {
      this.router.navigate(["/dashboard"])
    }

  }

  validateForm(): boolean {
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
