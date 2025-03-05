import { Component } from '@angular/core';
import { ProjectsComponent as projectsList } from '../../components/dashboard/proyects/projects.component';
import { DashboardComponent } from '../dashboard/dashboard.component';
import { AppComponent } from '../../app.component';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'view-projects',
  standalone: true,
  imports: [projectsList],
  templateUrl: './projects.component.html',
  styleUrl: './projects.component.css'
})
export class ProjectsComponent {
  projects: any = []
  usersPhotos: {id:number|string, photo:string|null}[] = []

  constructor (private app:AppComponent, private dashboard:DashboardComponent){}

  async ngOnInit() {
    //Load cache
    const projectsCache = this.dashboard.getCache("projects")
    const photosCache = this.dashboard.getCache("projectsPhotos")

    if (projectsCache) {
      this.projects = projectsCache.data

    } else {
      const projects = await this.dashboard.loadProjects()

      this.projects = projects

      this.dashboard.setCache("projects", this.projects)

    }

    if (photosCache) {
      this.usersPhotos = photosCache.data

    } else {
      const photos = await this.dashboard.loadPorjectsUsersPhotos()

      this.usersPhotos = photos

      this.dashboard.setCache("projectsPhotos", this.usersPhotos)
    }
  }
}
