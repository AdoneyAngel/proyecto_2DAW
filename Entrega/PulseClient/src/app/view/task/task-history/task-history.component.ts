import { Component } from '@angular/core';
import { AppComponent } from '../../../app.component';
import { DashboardComponent } from '../../dashboard/dashboard.component';
import { ActivatedRoute, Params } from '@angular/router';
import { getIssue, getTask, getTaskHistory } from '../../../../API/api';
import { ProjectComponent } from '../../projects/project/project.component';
import { MainContentBoxComponent } from '../../../components/main-content-box/main-content-box.component';
import TaskStatusEnum from '../../../enums/TaskStatusEnmu';

@Component({
  selector: 'app-task-history',
  standalone: true,
  imports: [MainContentBoxComponent],
  templateUrl: './task-history.component.html',
  styleUrl: './task-history.component.css'
})
export class TaskHistoryComponent {
  taskId: number | string = ""
  task:any = null
  history:any = []
  taskStatusEnum:any = TaskStatusEnum

  constructor(private projectComponent:ProjectComponent, private app: AppComponent, private dashboard: DashboardComponent, private activatedRoute: ActivatedRoute) { }

  ngOnInit() {
    this.projectComponent.setOnMain(false)
    this.dashboard.setTitle("Task history")
    this.dashboard.setRouteCustomTitle("taskHistory", "Task history");

    this.loadTaskId()

    this.loadHistory()
  }

  ngOnDestroy() {
    this.projectComponent.setOnMain(true)
  }

  async loadHistory() {
    const res = await  getTaskHistory(this.taskId)

    if (res.success) {
      this.history = res.data.reverse()

    } else {
      this.app.notificationError(res.errror ?? "Something gone wrong")
    }
  }

  loadTaskId() {
    this.activatedRoute.params.subscribe(
      (params: Params) => {
        this.taskId = params["id"]

        this.loadTask()
      }
    )
  }

  loadTask() {
    const fn = (id: number | string, project: boolean, users: boolean) => {
      if (this.app.getTitle() == "issueHistory") {
        return getIssue(id, project, users)

      } else {
        return getTask(id, project, users)
      }
    }

    fn(this.taskId, true, true)
      .then(res => {
        if (res.success) {
          this.task = res.data

          this.dashboard.setTitle("")
          this.dashboard.setRouteCustomTitle("task", res.data.title)

        } else {
          this.app.notificationError(res.error)
        }
      })
  }
}
