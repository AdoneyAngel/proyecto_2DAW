import { Component } from '@angular/core';
import { getIncludedProjects, getProjects, getTaskOfProject } from '../../../API/api';
import { AppComponent } from '../../app.component';
import { ProjectItemComponent } from '../../components/rack/project-item/project-item.component';
import { DashboardComponent } from '../dashboard/dashboard.component';

@Component({
  selector: 'app-rack',
  standalone: true,
  imports: [ProjectItemComponent],
  templateUrl: './rack.component.html',
  styleUrl: './rack.component.css'
})
export class RackComponent {
  projects:any = []

  constructor (private app:AppComponent, private dashboard: DashboardComponent) {}

  ngOnInit() {
    this.loadTasks()
  }

  async loadTasks() {
    //Load cache
    const projectsFromCache = this.dashboard.getCache("rack")

    if (projectsFromCache) {
      this.projects = projectsFromCache.data
    }

    //API load
    const projects = await getIncludedProjects(true)

    if (!projects.success) {
      this.app.notificationError(projects.error)
    }

    for (let actualProject of projects.data) {
      const tasksOfProject = await getTaskOfProject(actualProject.id, true, true)

      if (tasksOfProject.success) {
        actualProject.tasks = tasksOfProject.data

      } else {
        actualProject.tasks = []
      }
    }

    if (this.isChanged(projects.data)) {
      this.projects = projects.data

      this.dashboard.setCache("rack", this.projects)
    }
  }

  isChanged(newProjectsData:any) {
    let changes = false

    newProjectsData.forEach((actualProject:any) => {
      if (!this.projects.some((actualLocalProject:any) => actualLocalProject.id==actualProject.id)) {
        changes = true
      }

      actualProject.tasks.forEach((actualTask:any) => {
        this.projects.forEach((actualLocalProject:any) => {

          if (actualProject.id == actualLocalProject.id && actualProject.title != actualLocalProject.title) {
            changes = true
          }

          const taskFound = actualLocalProject.tasks.find((actualLocalTask:any) => actualLocalTask.id == actualTask.id)
          if (!taskFound) {
            changes = true

          } else {
            if (taskFound.title != actualTask.title) {
              changes = true
            }

            if (taskFound.description != actualTask.description) {
              changes = true
            }
          }
        })
      })
    })

    return changes
  }
}
