import { Component, Input } from '@angular/core';
import { MainContentBoxComponent } from '../../main-content-box/main-content-box.component';
import { InvitationItemComponent } from './invitation-item/invitation-item.component';

@Component({
  selector: 'app-invitations',
  standalone: true,
  imports: [MainContentBoxComponent, InvitationItemComponent],
  templateUrl: './invitations.component.html',
  styleUrl: './invitations.component.css'
})
export class InvitationsComponent {
  @Input() invitations: any = []
}
