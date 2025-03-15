import { Component } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { getMember, getProject } from '../../../API/api';
import { ProjectComponent } from '../projects/project/project.component';
import { AppComponent } from '../../app.component';
import { DashboardComponent } from '../dashboard/dashboard.component';

@Component({
  selector: 'app-member',
  standalone: true,
  imports: [],
  templateUrl: './member.component.html',
  styleUrl: './member.component.css'
})
export class MemberComponent {
  memberId:string|number|null = null
  projectId:string|number|null = null
  member:any = null
  project:any = null

  constructor (private activatedRoute:ActivatedRoute, private projectComponent:ProjectComponent, private app:AppComponent, private dashboard:DashboardComponent){}

  ngOnInit() {
    this.loadParams()
  }

  ngOnDestroy() {
    this.projectComponent.setOnMain(true)
  }

  ngDoCheck() {
    this.projectComponent.setOnMain(false)
  }

  loadParams() {
      this.activatedRoute.params.subscribe(
        (params:Params) => {
          this.memberId = params["memberId"]
          this.projectId = this.projectComponent.getProjectId()

          this.loadMember()
          this.loadProject()
        }
      )
  }

  async loadMember():Promise<any> {
    if (!this.memberId) return null
    if (!this.projectId) return null

    getMember(this.projectId, this.memberId)
    .then(res => {
      if (res.success) {
        this.member = res.data

        this.dashboard.setRouteCustomTitle("member", res.data.username)
        this.dashboard.setTitle(res.data.username)

      } else {
        this.app.notificationError(res.error)
      }
    })

  }

  async loadProject():Promise<any> {
    if (!this.memberId) return null
    if (!this.projectId) return null

    getProject(this.projectId)
    .then(res => {
      if (res.success) {
        this.project = res.data

      } else {
        this.app.notificationError(res.error)
      }
    })

  }
}
