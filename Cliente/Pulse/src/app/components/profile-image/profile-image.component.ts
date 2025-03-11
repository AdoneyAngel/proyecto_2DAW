import { Component, Input } from '@angular/core';
import { getUser } from '../../../API/api';
import { AppComponent } from '../../app.component';

@Component({
  selector: 'app-profile-image',
  standalone: true,
  imports: [],
  templateUrl: './profile-image.component.html',
  styleUrl: './profile-image.component.css'
})
export class ProfileImageComponent {
  @Input() image:string = "";
  @Input() styles:any = {}
  @Input() username:string = ""
  @Input() show:boolean = false
  @Input() userId:string|number = ""
  showProfileInfo:boolean = false
  color:string = "transparent"
  isLoading:boolean = false
  profile:any|null = null

  constructor (protected app:AppComponent) {}

  randomColor():string {
    const colors = ["profile-purple", "profile-red", "profile-blue", "profile-green"]
    const random:any = (Math.random()* (3 - 0) + 0).toFixed(0)

    return `var(--${colors[random]})`
  }

  setLetterStyles() {
    const styles = `background: ${this.color}; box-shadow: 0px 0px 0px 1000px ${this.color}`

    return styles
  }

  ngOnInit() {
    this.color = this.randomColor()
  }

  toggleShowProfileInfo(event:any) {
    event.stopPropagation()

    this.showProfileInfo = !this.showProfileInfo

    if (this.showProfileInfo) this.loadProfile()
  }

  async loadProfile() {
    if (!this.userId) return null
    if (this.profile || this.profile?.id) return null

    this.isLoading = true

    getUser(this.userId)
    .then(res => {
      if (res.success) {
        this.profile = res.data

      } else {
        this.app.notificationError(res.error)
      }
    })
    .finally(() => this.isLoading = false)

    return true
  }
}
