import { Component, Input } from '@angular/core';
import { ProfileImageComponent } from '../../../../components/profile-image/profile-image.component';
import TaskStatusEnum from '../../../../enums/TaskStatusEnmu';
import UserTaskStatusEnum from '../../../../enums/UserTaskStatusEnum';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-task',
  standalone: true,
  imports: [ProfileImageComponent, RouterLink],
  templateUrl: './task.component.html',
  styleUrls: ["../../../../../styles/dashboardItem.css", './task.component.css']
})
export class TaskComponent {
  @Input() task:any = {}
  todoEnum:number = 1
  progressEnum:number = 1
  reviewEnum:number = 1
  doneEnum:number = 1

  userTodoEnum:number = 1
  userProgressEnum:number = 1
  userDoneEnum:number = 1

  constructor (){
    this.todoEnum = TaskStatusEnum.Todo
    this.progressEnum = TaskStatusEnum.Progress
    this.reviewEnum = TaskStatusEnum.Review
    this.doneEnum = TaskStatusEnum.Done

    this.userTodoEnum = UserTaskStatusEnum.Todo
    this.userProgressEnum = UserTaskStatusEnum.Progress
    this.userDoneEnum = UserTaskStatusEnum.Done
  }
}
