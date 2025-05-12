import { Component, Input } from '@angular/core';
import { PopupBackgroundComponent } from '../popup-background/popup-background.component';

@Component({
  selector: 'app-options',
  standalone: true,
  imports: [PopupBackgroundComponent],
  templateUrl: './options.component.html',
  styleUrl: './options.component.css'
})
export class OptionsComponent {
  @Input() buttons:any = []
  @Input() title:string = ""
  @Input() closeCallback:VoidFunction|any = ()=>{}


  actionAndClose(action:VoidFunction) {
    action()
    this.closeCallback()
  }
}
