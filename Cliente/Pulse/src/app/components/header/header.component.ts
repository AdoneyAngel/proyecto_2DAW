import { Component, ElementRef, Input, SimpleChanges, ViewChild } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { DashboardComponent } from '../../view/dashboard/dashboard.component';
import { AppComponent } from '../../app.component';
import { ProfileImageComponent } from '../profile-image/profile-image.component';
import { NgIf } from '@angular/common';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [RouterLink, ProfileImageComponent, RouterLink, NgIf],
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {
  @Input() routes:any = []
  @Input() photo:string|null = null
  @Input() username:string = ""
  @Input() showLateralBar:VoidFunction = () => {}
  @ViewChild("routerList") routerList!:ElementRef
  visibleRoutes:any = []

  constructor (protected app:AppComponent, private router:Router) {}

  ngOnInit() {
  }

  ngAfterViewInit() {
    this.checkVisibleRoutes()
  }

  ngOnChanges(changes:SimpleChanges) {
    if (this.routerList && changes["routes"]) {
      this.checkVisibleRoutes()

    }

  }

  checkVisibleRoutes () {
    const rects = this.routerList.nativeElement.getClientRects()
    const width = this.routerList.nativeElement.offsetWidth

    const nVisibleRoutes = Math.floor(width / 120)

    const routesStart = (this.routes.length - (nVisibleRoutes)) < 0 ? 0 : this.routes.length - nVisibleRoutes

    this.visibleRoutes = this.routes.slice(routesStart)
  }

  goToProfile() {
    this.router.navigate(["/dashboard/profile"])
  }
}
