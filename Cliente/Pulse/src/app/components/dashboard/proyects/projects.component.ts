import { Component, Input } from '@angular/core';
import { MainContentBoxComponent } from '../../main-content-box/main-content-box.component';
import { ProjectItemComponent } from './project-item/project-item.component';

@Component({
  selector: 'app-projects',
  standalone: true,
  imports: [MainContentBoxComponent, ProjectItemComponent],
  templateUrl: './projects.component.html',
  styleUrl: './projects.component.css'
})
export class ProjectsComponent {
  @Input() projects:any = []
}
