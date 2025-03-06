import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-profile-image',
  standalone: true,
  imports: [],
  templateUrl: './profile-image.component.html',
  styleUrl: './profile-image.component.css'
})
export class ProfileImageComponent {
  @Input() image:string = "";
  @Input() styles:any = {}
}
