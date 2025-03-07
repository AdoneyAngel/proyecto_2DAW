import { Component, Input } from '@angular/core';
import { MainContentBoxComponent } from '../../main-content-box/main-content-box.component';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-create-task-form',
  standalone: true,
  imports: [MainContentBoxComponent, FormsModule],
  templateUrl: './create-task-form.component.html',
  styleUrl: './create-task-form.component.css'
})
export class CreateTaskFormComponent {
  title:string = ""
  description:string = ""
  tag:string = ""
  priority:string = ""
  time:string = ""
  users:any = []
  @Input() submit:VoidFunction = ()=>{}
  @Input() tags:any = []
  @Input() memberes:any = []
}
