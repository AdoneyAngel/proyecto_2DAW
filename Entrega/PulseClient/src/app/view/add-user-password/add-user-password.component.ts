import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { AppComponent } from '../../app.component';
import { addUserPassword } from '../../../API/api';
import { Router } from '@angular/router';

@Component({
  selector: 'app-add-user-password',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './add-user-password.component.html',
  styleUrl: './add-user-password.component.css'
})
export class AddUserPasswordComponent {
  password:string = ""

  constructor (protected app:AppComponent, private router:Router) {}

  async submit(event:Event) {
    event.preventDefault()

    if (this.password) {
      const res = await addUserPassword(this.password)

      if (res.success) {
        this.router.navigate([this.app.getLastRoute()??"/dashboard"])

      } else {
        this.app.notificationError(res.error)
      }

    }
  }
}
