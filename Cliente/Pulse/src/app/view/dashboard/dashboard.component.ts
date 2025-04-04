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
  profile:any = {
    photo: "",
    username: ""
  }
  isOnDashboard: boolean = true
  routes: any = []
  invitations: any[] = []
  projects: any = []
  title:string = ""
  usersPhotos: {id:number|string, photo:string|null}[] = []
  cache:{name:string, data:any}[] = []

  constructor(private appComponent: AppComponent, private activatedRoute: ActivatedRoute){}

  async ngOnInit() {
    this.onRouteChanges()

    this.appComponent.onLoadUser(this.loadProfile.bind(this))
    this.appComponent.onRouteChanges("dashboard", this.onRouteChanges.bind(this))
  }

  loadProfile() {
    this.profile.username = this.appComponent.getUser().username

    this.findUserPhoto(this.appComponent.getUser().id)
    .then(res => this.profile.photo = res.photo)
  }

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
  removeCache(name:string) {
    this.cache = this.cache.filter((actualCache:any) => actualCache.name !== name)
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

  setTitle(title:string) {
    this.title = title
  }
  setRouteCustomTitle(routeTitle:string, newTitle:string) {
    this.routes.forEach((actualRoute:any) => {
      if (actualRoute.title == routeTitle) {
        actualRoute.customTitle = newTitle
      }
    })
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
    const projects = await getIncludedProjects(true, true);

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
        const photoUrl = await this.findUserPhoto(actualMember.id)

        this.usersPhotos = [...this.usersPhotos, {
          id: actualMember.id,
          photo: photoUrl.photo
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
  addUserPhoto(userId:number|string, photo:string) {
    this.usersPhotos = [...this.usersPhotos, {id:userId, photo}]
  }

  findLocalUserPhoto(userId:number|string) {
    const photoFound = this.usersPhotos.find(actualPhoto => actualPhoto.id==userId)

    if (photoFound) {
      return photoFound

    } else {
      return null
    }
  }
  async findUserPhoto(userId:number|string) {
    //Locad local
    const photoFound = this.findLocalUserPhoto(userId)

    if (photoFound) {
      return photoFound
    }
    //Load API if dont exist on local
    const res = await getUserPhoto(userId)

    if (res) {
      this.usersPhotos = [...this.usersPhotos,{id:userId, photo:res}]

      return {
        id: userId,
        photo: res
      }
    }

    this.usersPhotos = [...this.usersPhotos,{id:userId, photo: null}]
    return {
      id: userId,
      photo: null
    }
  }
}
