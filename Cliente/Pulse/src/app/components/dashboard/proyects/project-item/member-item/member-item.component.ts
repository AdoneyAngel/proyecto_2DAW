import { Component, Input } from '@angular/core';
import { AppComponent } from '../../../../../app.component';
import { ProfileImageComponent } from '../../../../profile-image/profile-image.component';
import { DashboardComponent } from '../../../../../view/dashboard/dashboard.component';

@Component({
  selector: 'app-member-item',
  standalone: true,
  imports: [ProfileImageComponent],
  templateUrl: './member-item.component.html',
  styleUrl: './member-item.component.css'
})
export class MemberItemComponent {
  @Input() user:any = {}
  @Input() userPhoto:any = null
  sameUser:boolean = false

  constructor (protected app:AppComponent, private dashboard:DashboardComponent){}

  async ngOnInit() {
    if (!this.user.photo) {
      this.loadPhoto(this.user.id)
    }
    this.sameUser = this.app.getUser().id == this.user.id
  }

  async loadPhoto(userId:number|string) {
    const photoUrl = await this.dashboard.findUserPhoto(userId)

    if (photoUrl) {
      this.userPhoto = photoUrl
    }
  }
}
