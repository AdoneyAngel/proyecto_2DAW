import { Component } from '@angular/core';
import { ActivatedRoute, RouterOutlet } from '@angular/router';
import { HeaderComponent } from '../../components/header/header.component';
import { LateralBarComponent } from '../../components/lateral-bar/lateral-bar.component';
import { AppComponent } from '../../app.component';
import { acceptInvitation, getInvitations, getIncludedProjects, rejectInvitation } from '../../../API/api';
import { InvitationsComponent } from '../../components/dashboard/invitations/invitations.component';
import { ProjectsComponent } from '../../components/dashboard/proyects/projects.component';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [RouterOutlet, HeaderComponent, LateralBarComponent, InvitationsComponent, ProjectsComponent],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export class DashboardComponent {
  isOnDashboard: boolean = true
  routes: any = []
  invitations: any[] = []
  projects: any = []
  title:string = "Dashboard"

  constructor(private appComponent: AppComponent, private activatedRoute: ActivatedRoute){}

  async acceptInvitation(projectId:number|string) {
    const res = await acceptInvitation(projectId)

    if (res.success) {
      this.appComponent.notificationSuccess("Invitation accepted")
      this.invitations = this.invitations.filter(invitation => invitation.projectId != projectId)

    } else {
      this.appComponent.notificationError(res.error)
    }
  }
  async rejectInvitation(projectId:number|string) {
    const res = await rejectInvitation(projectId)

    if (res.success) {
      this.appComponent.notificationSuccess("Invitation rejected")
      this.invitations = this.invitations.filter(invitation => invitation.projectId != projectId)

    } else {
      this.appComponent.notificationError(res.error)
    }
  }

  async ngOnInit() {
    this.routes = this.appComponent.getRouteInfo(this.activatedRoute.root, '');
    this.title = this.appComponent.getTitle()
    if (this.title !== "dashboard") {
      this.isOnDashboard = false
    }

    //If is on main dashboard
    if (this.isOnDashboard) {
      this.loadInvitations()
      this.loadProjects()
    }
  }

  //Loads
  async loadInvitations() {
    const inivitationsRes = await getInvitations()

    if (inivitationsRes.success) {
      this.invitations = inivitationsRes.data

    } else {
      this.appComponent.notificationError(inivitationsRes.error)
    }
  }

  async loadProjects() {
    const projects = await getIncludedProjects();

    if (projects.success) {
      this.projects = projects.data
    }
  }
}
