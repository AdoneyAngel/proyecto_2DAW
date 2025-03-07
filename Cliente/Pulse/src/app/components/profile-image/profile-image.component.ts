import { Component, Input } from '@angular/core';

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
  color:string = "transparent"

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
}
