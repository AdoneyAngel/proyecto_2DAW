import { Component, Input } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { DashboardComponent } from '../../view/dashboard/dashboard.component';
import { AppComponent } from '../../app.component';
import { ProfileImageComponent } from '../profile-image/profile-image.component';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [RouterLink, ProfileImageComponent, RouterLink],
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {
  @Input() routes:any = []
  @Input() photo:string|null = null
  @Input() username:string = ""

  constructor (private router:Router) {}

  goToProfile() {
    this.router.navigate(["/dashboard/profile"])
  }
}
