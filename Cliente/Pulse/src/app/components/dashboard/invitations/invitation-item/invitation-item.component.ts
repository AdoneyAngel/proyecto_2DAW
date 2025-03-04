import { Component, Input } from '@angular/core';
import { DashboardComponent } from '../../../../view/dashboard/dashboard.component';
import { AppComponent } from '../../../../app.component';

@Component({
  selector: 'app-invitation-item',
  standalone: true,
  imports: [],
  templateUrl: './invitation-item.component.html',
  styleUrls: ['./invitation-item.component.css', "../../../../../styles/dashboardItem.css"]
})
export class InvitationItemComponent {
  @Input() invitation: any = {}
  loading: boolean = false

  constructor(private dashboard: DashboardComponent, private app: AppComponent){}

  showOptions() {
    this.app.showOptions("Do you accept the invitation?", [
      {
        name: "Reject",
        action: this.rejectNotification.bind(this),
        type: "cancel"
      },
      {
        name: "Accept",
        action: this.acceptNotification.bind(this),
        type: "accept"
      }
    ])
  }

  acceptNotification() {
    this.loading = true

    this.dashboard.acceptInvitation(this.invitation.proyectId)
  }

  rejectNotification() {
    this.loading = true

    this.dashboard.rejectInvitation(this.invitation.proyectId)
  }
}
