import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-text-link',
  standalone: true,
  imports: [],
  templateUrl: './text-link.component.html',
  styleUrl: './text-link.component.css'
})
export class TextLinkComponent {
  @Input() text:string = ""
  @Input() link:string = ""
  @Input() styles:string = ""
}
