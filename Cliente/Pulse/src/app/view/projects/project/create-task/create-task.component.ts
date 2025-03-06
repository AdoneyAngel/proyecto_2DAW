import { Component } from '@angular/core';
import { CreateTaskFormComponent } from '../../../../components/createTask/create-task-form/create-task-form.component';
import { ActivatedRoute, Params } from '@angular/router';
import { getTags } from '../../../../../API/api';
import { AppComponent } from '../../../../app.component';

@Component({
  selector: 'app-create-task',
  standalone: true,
  imports: [CreateTaskFormComponent],
  templateUrl: './create-task.component.html',
  styleUrl: './create-task.component.css'
})
export class CreateTaskComponent {
  projectId:string|number = 0
  title:string = ""
  description:string = ""
  tag:string = ""
  priority:string = ""
  time:string = ""
  users:any = []
  tags:any = []

  constructor (private activedRouter:ActivatedRoute, protected app:AppComponent){}

  ngOnInit() {
    this.activedRouter.params.subscribe(
      (param:Params) => {
        this.projectId = param["id"]

        this.loadTags()
      }
    )
  }

  async submit() {

  }

  validateForm():boolean {


    return true
  }

  async loadTags() {
    getTags(this.projectId)
    .then(res => {
      if (res.success) {
        this.tags = res.data

      } else {
        this.app.notificationError(res.error);
      }
    })
  }
}
