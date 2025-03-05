import { Component, Input } from '@angular/core';
import { getUserPhoto } from '../../../../../../API/api';
import { AppComponent } from '../../../../../app.component';

@Component({
  selector: 'app-member-item',
  standalone: true,
  imports: [],
  templateUrl: './member-item.component.html',
  styleUrl: './member-item.component.css'
})
export class MemberItemComponent {
  @Input() user:any = {}
  @Input() userPhoto:any = null
  sameUser:boolean = false

  constructor (protected app:AppComponent){}

  async ngOnInit() {
    if (!this.user.photo) {
      this.loadPhoto(this.user.id)
    }
    this.sameUser = this.app.getUser().id == this.user.id
  }

  async loadPhoto(userId:number|string) {
    const photoUrl = await getUserPhoto(userId)

    if (photoUrl) {
      this.userPhoto = photoUrl
    }
  }
}
