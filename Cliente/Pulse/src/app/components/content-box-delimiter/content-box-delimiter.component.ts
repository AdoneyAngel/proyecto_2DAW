import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-content-box-delimiter',
  standalone: true,
  imports: [],
  templateUrl: './content-box-delimiter.component.html',
  styleUrl: './content-box-delimiter.component.css'
})
export class ContentBoxDelimiterComponent {
  @Input() title:string = ""
}
