import { Component, ElementRef, Input, ViewChild } from '@angular/core';
import { getUser } from '../../../API/api';
import { AppComponent } from '../../app.component';
import { DashboardComponent } from '../../view/dashboard/dashboard.component';

@Component({
  selector: 'app-profile-image',
  standalone: true,
  imports: [ProfileImageComponent],
  templateUrl: './profile-image.component.html',
  styleUrl: './profile-image.component.css'
})
export class ProfileImageComponent {
  @Input() image:string = "";
  @Input() styles:any = {}
  @Input() username:string = ""
  @Input() show:boolean = false
  @Input() userId:string|number = ""
  @Input() onclick:Function|null = null
  color:string = "transparent"
  isLoading:boolean = false
  profile:any|null = null
  focused:boolean = false
  containerPos:any = {
    x:0,
    y:0
  }

  @ViewChild("profileImageContainer") profileImageContainer!: ElementRef;

  constructor (protected app:AppComponent, private dashboard:DashboardComponent) {}

  ngOnInit() {
    this.color = this.randomColor()
  }

  randomColor():string {
    const colors = ["profile-purple", "profile-red", "profile-blue", "profile-green"]
    const random:any = (Math.random()* (3 - 0) + 0).toFixed(0)

    return `var(--${colors[random]})`
  }

  setLetterStyles() {
    const styles = `background: ${this.color}; box-shadow: 0px 0px 0px 1000px ${this.color}`

    return styles
  }


  async loadProfile() {
    if (!this.userId) return null
    if (this.profile || this.profile?.id) return null

    this.isLoading = true

    getUser(this.userId)
    .then(res => {
      if (res.success) {
        this.profile = res.data

        if (!this.image) this.loadProfilePhoto()

      } else {
        this.app.notificationError(res.error)
      }
    })
    .finally(() => this.isLoading = false)

    return true
  }

  onProfileFocus () {
    this.focused = true

    const dimensions = this.profileImageContainer.nativeElement.getClientRects()[0]

    this.containerPos = {
      x: (dimensions.x + dimensions.width/2),
      y: dimensions.y
    }

    if (!this.profile) this.loadProfile()
  }
  onProfileBlur () {
    this.focused = false
  }

  onProfileClick(event:any) {
    event.stopPropagation();
  }

  loadProfilePhoto() {
    console.log("cargando foto")

    this.dashboard.findUserPhoto(this.userId)
    .then((res:any) => {
      this.image = res.photo
    })

    return
  }
}
