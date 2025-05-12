import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { MemberItemComponent } from './member-item/member-item.component';
import { AppComponent } from '../../../../app.component';
import { RouterLink } from '@angular/router';
import { DashboardComponent } from '../../../../view/dashboard/dashboard.component';

@Component({
  selector: 'app-project-item',
  standalone: true,
  imports: [MemberItemComponent, RouterLink],
  templateUrl: './project-item.component.html',
  styleUrls: ['./project-item.component.css', "../../../../../styles/dashboardItem.css"]
})
export class ProjectItemComponent implements OnChanges {
  @Input() project:any = {}
  @Input() usersPhotos:any = []

  constructor (protected app:AppComponent, private dashboard:DashboardComponent){}

  async ngOnChanges(changes: SimpleChanges) {

    this.project.members = this.project.members.map((actualMember: {id:string|number,photoUrl:string|null}) => {

      const photoData = this.usersPhotos.find((actualPhoto:{id:string|number, photo:string|null}) => actualPhoto.id==actualMember.id)

      const updatedMember = {...actualMember, photo:photoData?photoData.photo:""}

      return updatedMember
    })

    const ownerPhoto = await this.dashboard.findUserPhoto(this.project.owner.id)

    this.project.owner.photo = ownerPhoto.photo
  }

}
