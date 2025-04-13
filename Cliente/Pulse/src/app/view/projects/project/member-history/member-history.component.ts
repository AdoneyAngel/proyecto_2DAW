import { Component } from '@angular/core';
import { ProjectComponent } from '../project.component';
import { AppComponent } from '../../../../app.component';
import { DashboardComponent } from '../../../dashboard/dashboard.component';
import { getMemberHistory } from '../../../../../API/api';
import { MainContentBoxComponent } from '../../../../components/main-content-box/main-content-box.component';

@Component({
  selector: 'app-member-history',
  standalone: true,
  imports: [MainContentBoxComponent],
  templateUrl: './member-history.component.html',
  styleUrl: './member-history.component.css'
})
export class MemberHistoryComponent {
  history:any = []

  constructor (private dashboard:DashboardComponent, private app:AppComponent, private projectComponent:ProjectComponent) {}

  ngOnInit() {
    this.dashboard.setTitle("Members history")
    this.dashboard.setRouteCustomTitle("memberHistory", "Member History")
    this.projectComponent.setOnMain(false)

    this.loadHistory()
  }

  ngOnDestroy() {
    this.projectComponent.setOnMain(true)
  }

  async loadHistory() {
    try {
      const res = await getMemberHistory(this.projectComponent.getProjectId())

      if (res.success) {
        this.history = res.data

      } else {
        this.app.notificationError(res.error ?? "Something gone wrong")
      }

    } catch (err) {
      this.app.notificationError("Something gone wrong")
    }
  }
}
