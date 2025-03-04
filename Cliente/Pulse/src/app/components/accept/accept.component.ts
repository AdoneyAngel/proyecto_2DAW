import { Component, Input } from '@angular/core';
import { PopupBackgroundComponent } from '../popup-background/popup-background.component';

@Component({
  selector: 'app-accept',
  standalone: true,
  imports: [PopupBackgroundComponent],
  templateUrl: './accept.component.html',
  styleUrl: './accept.component.css'
})
export class AcceptComponent {
  @Input() closeCallback: any = ()=>{}
  @Input() callback: any = ()=>{}
  @Input() title: string = "Are you sure to delete it?"

}
