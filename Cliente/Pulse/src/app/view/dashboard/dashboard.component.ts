import { Component } from '@angular/core';
import { ActivatedRoute, RouterOutlet } from '@angular/router';
import { HeaderComponent } from '../../components/header/header.component';
import { LateralBarComponent } from '../../components/lateral-bar/lateral-bar.component';
import { AppComponent } from '../../app.component';
import { acceptInvitation, getInvitations, getIncludedProjects, rejectInvitation, getUserPhoto } from '../../../API/api';
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
  usersPhotos: {id:number|string, photo:string|null}[] = []
  cache:{name:string, data:any}[] = []

  constructor(private appComponent: AppComponent, private activatedRoute: ActivatedRoute){}

  getCache(name:string) {
    const cacheFound = this.cache.find(actualCache => actualCache.name == name)

    return cacheFound
  }
  setCache(name:string, data:any) {
    let cacheExist = false

    this.cache = this.cache.map(actualCache => {
      if (actualCache.name === name) {
        actualCache.data = data
        cacheExist = true

      }

      return actualCache
    })

    if (!cacheExist) {
      this.cache = [...this.cache, {name, data}]
    }
  }

  //Invitations
  async acceptInvitation(projectId:number|string) {
    const res = await acceptInvitation(projectId)

    if (res.success) {
      this.appComponent.notificationSuccess("Invitation accepted")
      const updatedInvitationList = this.invitations.filter(invitation => invitation.proyectId != projectId)
      this.invitations = updatedInvitationList

      console.log(updatedInvitationList)

    } else {
      this.appComponent.notificationError(res.error)
    }
  }
  async rejectInvitation(projectId:number|string) {
    const res = await rejectInvitation(projectId)

    if (res.success) {
      this.appComponent.notificationSuccess("Invitation rejected")
      this.invitations = this.invitations.filter(invitation => invitation.proyectId != projectId)

    } else {
      this.appComponent.notificationError(res.error)
    }
  }

  async ngOnInit() {
    this.onRouteChanges()

    this.appComponent.onRouteChanges(this.onRouteChanges.bind(this))
  }

  private onRouteChanges() {
    this.routes = this.appComponent.getRouteInfo(this.activatedRoute.root, '');
    this.title = this.appComponent.getTitle()

    if (this.title !== "dashboard") {
      this.isOnDashboard = false

    } else {
      this.isOnDashboard = true
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
      //Validate if there are changes with the last load
      let changes = false

      for (let projectIndex = 0; projectIndex<projects.data.length; projectIndex++) {
        const actualProject = projects.data[projectIndex]

        let isLoaded = false;

        for (let loadedProjectIndex = 0; loadedProjectIndex<this.projects.length; loadedProjectIndex++) {
          const actualLoadedProject: {
            id:string|number,
            title:string,
            ownerId:string|number
            date:string
            members: {
              id:string|number,
              username:string,
              email:string
            }[]
          } = this.projects[projectIndex]
          if (actualLoadedProject.id == actualProject.id) {
            isLoaded = true

            if (actualLoadedProject.title != actualProject.title) isLoaded = false;
            if (actualLoadedProject.date != actualProject.date) isLoaded = false;
            if (actualLoadedProject.ownerId != actualProject.ownerId) isLoaded = false;

            if (!actualProject.members.every((actualProjectMember: {id:string|number,username:string,email:string}) => {
              return actualLoadedProject.members.some(a => a.id == actualProjectMember.id)
            })) {
              isLoaded = false
            }
          }
        }

        if (!isLoaded) {
          changes = true
        }
      }

      if (changes) {
        this.projects = projects.data
        this.loadPorjectsUsersPhotos()
      }

      return this.projects
    }
  }

  async loadPorjectsUsersPhotos() {
    for(let actualProject of this.projects){
      for(let actualMember of actualProject.members) {
        const photoUrl = await getUserPhoto(actualMember.id)

        this.usersPhotos = [...this.usersPhotos, {
          id: actualMember.id,
          photo: photoUrl
        }]
      }
    }
    return this.usersPhotos
  }

  getProjects() {
    return this.projects
  }
  getUsersPhotos() {
    return this.usersPhotos
  }
}
