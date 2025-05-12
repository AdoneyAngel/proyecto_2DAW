import { Component, Input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { getProjects } from '../../../API/api';
import { AppComponent } from '../../app.component';
import { ProjectListComponent } from './project-list/project-list.component';
import { NgIf } from '@angular/common';

@Component({
  selector: 'app-lateral-bar',
  standalone: true,
  imports: [RouterLink, ProjectListComponent, NgIf],
  templateUrl: './lateral-bar.component.html',
  styleUrl: './lateral-bar.component.css'
})
export class LateralBarComponent {
  projects:any = []
  @Input() hidde:VoidFunction = () => {}

  constructor (protected app:AppComponent){}

  ngOnInit() {
    this.loadProjects()
  }

  async loadProjects() {
    getProjects().then(projects => {
      if (projects.success) {
        this.projects = projects.data

      } else {
        this.app.notificationError(projects.error);
      }

    })
  }
}
