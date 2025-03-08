import { Component, Input } from '@angular/core';
import { MainContentBoxComponent } from '../../main-content-box/main-content-box.component';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-project-item',
  standalone: true,
  imports: [MainContentBoxComponent, RouterLink],
  templateUrl: './project-item.component.html',
  styleUrls: ['./project-item.component.css', "../../../../styles/dashboardItem.css"]
})
export class ProjectItemComponent {
  @Input() project:any = []
}
