import { Component, Input } from '@angular/core';
import { getUserPhoto } from '../../../../../API/api';
import { MemberItemComponent } from './member-item/member-item.component';

@Component({
  selector: 'app-project-item',
  standalone: true,
  imports: [MemberItemComponent],
  templateUrl: './project-item.component.html',
  styleUrls: ['./project-item.component.css', "../../../../../styles/dashboardItem.css"]
})
export class ProjectItemComponent {
  @Input() project:any = {}

}
