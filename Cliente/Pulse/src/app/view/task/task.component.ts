import { Component } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { AppComponent } from '../../app.component';
import { getTask } from '../../../API/api';
import { DashboardComponent } from '../dashboard/dashboard.component';

@Component({
  selector: 'app-task',
  standalone: true,
  imports: [],
  templateUrl: './task.component.html',
  styleUrl: './task.component.css'
})
export class TaskComponent {
  taskId:number|string = 0
  task:any = {}

  constructor (private activatedRoute:ActivatedRoute, private app:AppComponent, private dashboard:DashboardComponent){}

  ngOnInit() {
    this.loadTaskId()
    this.app.onRouteChanges(this.loadTaskId.bind(this))
  }

  loadTaskId() {
    this.activatedRoute.params.subscribe(
      (params:Params) => {
        this.taskId = params["id"]

        this.loadTask()
      }
    )
  }

  loadTask() {
    getTask(this.taskId, true)
    .then(res => {
      if (res.success) {
        this.task = res.data

        this.dashboard.setTitle(res.data.title)
        this.dashboard.setRouteCustomTitle("task", res.data.title)

      } else {
        this.app.notificationError(res.error)
      }
    })
  }
}
