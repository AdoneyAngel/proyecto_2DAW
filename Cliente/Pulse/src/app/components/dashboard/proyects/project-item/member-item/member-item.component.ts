import { Component, Input } from '@angular/core';
import { getUserPhoto } from '../../../../../../API/api';

@Component({
  selector: 'app-member-item',
  standalone: true,
  imports: [],
  templateUrl: './member-item.component.html',
  styleUrl: './member-item.component.css'
})
export class MemberItemComponent {
  @Input() user:any = {}
  userPhoto:any = null

  async ngOnInit() {
    this.loadPhoto(this.user.id)
  }

  async loadPhoto(userId:number|string) {
    const photoUrl = await getUserPhoto(userId)

    if (photoUrl) {
      this.userPhoto = photoUrl
    }
  }
}
