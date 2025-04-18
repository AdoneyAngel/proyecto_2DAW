import { Component, SimpleChanges } from '@angular/core';
import { ActivatedRoute, NavigationEnd, NavigationStart, RouterOutlet } from '@angular/router';
import { Router } from '@angular/router';
import { filter } from 'rxjs/operators';
import { isLogged } from "../API/api"
import { NotificationComponent } from './components/notification/notification.component';
import { AcceptComponent } from './components/accept/accept.component';
import { OptionsComponent } from './components/options/options.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NotificationComponent, AcceptComponent, OptionsComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'Pulse';
  user:any = {}
  routeSuscripcions:any = []
  onLoadProfileFunc:any = []
  lastRoute:string = ""
  currentRoute:string = ""
  screenWidth:number = 0
  phoneScreen:boolean = false

  //Notifications
  notificationList = [
    {
      id: 0,
      message: "mensaje de ejemplo",
      type: ""
    }
  ]
  nNotifications: number = 0
  routeHistory = [{title:"", url:""}]

  //Accept
  visibleAccept: boolean = false
  acceptTitle: string = ""
  acceptCallback: any|null = () => {}

  //Options
  visibleOptions: boolean = false
  optionsButtons: any = []
  optionsTitle: string = ""

  constructor(private router: Router, private activatedRoute: ActivatedRoute, private route: ActivatedRoute) {}

  checkScreenFormat () {
    const width = window.innerWidth

    if (width <= 950) {
      this.phoneScreen = true
    }

    this.screenWidth = width
  }

  async onLoadUser(fn:Function) {
    this.onLoadProfileFunc.push(fn)
  }

  getLastRoute():string {
    return this.lastRoute
  }

  ngOnInit() {
    this.checkScreenFormat()

    this.notificationList = []

    this.router.events
      .pipe(filter(event => event instanceof NavigationEnd))
      .subscribe(async e => {
        //Check if the user is logged
        await isLogged()
        .then(logged => {
          const routeTitle = this.getTitle();

          //Manage current/previous path
          this.lastRoute = this.currentRoute
          this.currentRoute = e.urlAfterRedirects

          this.title = "Pulse - " + routeTitle

          //Save the route titles
          this.routeHistory = this.getRouteInfo(this.activatedRoute.root, '');

          if (!logged.success) {
            if (routeTitle !== "login" && routeTitle !== "signup") {
              this.router.navigate(["/login"])
            }

          } else {
            this.user = logged.data

            this.onLoadProfileFunc.forEach((actualFunc:Function) => actualFunc())
          }
        })
      });
  }

  showAccept(title:string, callback:VoidFunction) {
    this.acceptTitle = title
    this.acceptCallback = callback
    this.visibleAccept = true
  }
  hideAccept() {
    this.acceptTitle = ""
    this.visibleAccept = false
  }

  showOptions(title:string, buttons:{name:string,type:string,action:VoidFunction|any}[]) {
    this.optionsTitle = title
    this.optionsButtons = buttons
    this.visibleOptions = true
  }
  hideOptions() {
    this.visibleOptions = false
    this.optionsTitle = ""
    this.optionsButtons = []
  }

  notificationError(message: string) {
    this.nNotifications += 1

    const newMessage = {
      id: this.nNotifications,
      message: message,
      type: "error"
    }

    this.notificationList.push(newMessage)

    setTimeout(() => {
      this.notificationList = this.notificationList.filter(not => not.id != newMessage.id)
    }, 3000);

  }

  notification(message: string) {
    this.nNotifications += 1

    const newMessage = {
      id: this.nNotifications,
      message: message,
      type: "normal"
    }

    this.notificationList.push(newMessage)

    setTimeout(() => {
      this.notificationList = this.notificationList.filter(not => not.id != newMessage.id)
    }, 3000);
  }

  notificationSuccess(message: string) {
    this.nNotifications += 1

    const newMessage = {
      id: this.nNotifications,
      message: message,
      type: "success"
    }

    this.notificationList.push(newMessage)

    setTimeout(() => {
      this.notificationList = this.notificationList.filter(not => not.id != newMessage.id)
    }, 3000);
  }

  getRouteInfo(route: ActivatedRoute, parentUrl: string): { title: string, url: string }[] {
    let routesInfo: { title: string, url: string }[] = [];

    // Verificamos si la ruta tiene un título y lo añadimos
    if (route.snapshot.data['title']) {

      let fullUrl = parentUrl + '/' + route.snapshot.url.map(segment => segment.path).join('/');

      //Delete the extra "/"
      if (fullUrl[0] == "/" && fullUrl[1] == "/") {
        fullUrl = fullUrl.slice(1)
      }

      routesInfo.push({ title: route.snapshot.data['title'], url: fullUrl });
    }

    // Recorrer los hijos para obtener las rutas anidadas
    route.children.forEach(child => {
      routesInfo = routesInfo.concat(this.getRouteInfo(child, parentUrl + '/' + route.snapshot.url.map(segment => segment.path).join('/')));
    });

    return routesInfo;
  }

  getRouteHistory() {
    return this.routeHistory
  }

  getUser() {
    return this.user
  }

  // Función que recorre las rutas activas y obtiene el título
  getTitle(): string {
    let route = this.activatedRoute.root;  // Obtenemos la raíz de la ruta actual

    while (route.firstChild) {
      route = route.firstChild;  // Navegamos hasta la ruta activa más profunda
    }
    const title = route.snapshot.data['title'];  // Accedemos al título desde los datos de la ruta

    return title
  }

  async onRouteChanges(id:string|number, callback:VoidFunction) {
    let suscripcionExist = false

    this.routeSuscripcions.forEach((suscripcion:any) => {
      if (suscripcion.id == id) {
        suscripcionExist = true
        console.log("found: " + id)

        const newSuscripcion = this.router.events
        .pipe(filter(event => event instanceof NavigationEnd))  // Filtramos solo los eventos de finalización de navegación
        .subscribe(async e => {

          callback()

        });

        suscripcion.suscripcion.unsubscribe()

        suscripcion.suscripcion = newSuscripcion
      }
    })

    if (!suscripcionExist) {
      const newSuscripcion = this.router.events
      .pipe(filter(event => event instanceof NavigationEnd))  // Filtramos solo los eventos de finalización de navegación
      .subscribe(async e => {

        callback()

      });

      this.routeSuscripcions = [...this.routeSuscripcions, {id, suscripcion:newSuscripcion}]

    }
  }
}
