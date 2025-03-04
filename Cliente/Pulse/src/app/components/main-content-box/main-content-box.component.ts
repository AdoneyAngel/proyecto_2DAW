import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-main-content-box',
  standalone: true,
  imports: [],
  templateUrl: './main-content-box.component.html',
  styleUrl: './main-content-box.component.css'
})
export class MainContentBoxComponent {
  @Input() title: string = ""
}
