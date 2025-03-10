import { Component, Input } from '@angular/core';
import { PopupBackgroundComponent } from '../../../../components/popup-background/popup-background.component';

@Component({
  selector: 'app-member-search',
  standalone: true,
  imports: [PopupBackgroundComponent],
  templateUrl: './member-search.component.html',
  styleUrl: './member-search.component.css'
})
export class MemberSearchComponent {
  @Input() close:VoidFunction = ()=>{}
  @Input() project:any = {}
}
