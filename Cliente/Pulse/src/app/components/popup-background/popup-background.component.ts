import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-popup-background',
  standalone: true,
  imports: [],
  templateUrl: './popup-background.component.html',
  styleUrl: './popup-background.component.css'
})
export class PopupBackgroundComponent {
  @Input() closeCallback:VoidFunction = () => {}
}
