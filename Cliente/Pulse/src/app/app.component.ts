import { Component } from '@angular/core';
import { ActivatedRoute, NavigationEnd, RouterOutlet } from '@angular/router';
import { Router } from '@angular/router';
import { filter } from 'rxjs/operators';
import { isLogged } from "../API/api"
import { NotificationComponent } from './components/notification/notification.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NotificationComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'Pulse';
  notificationList = [
    {
      id: 0,
      message: "mensaje de ejemplo",
      type: ""
    }
  ]
  nNotifications: number = 0

  constructor(private router: Router, private activatedRoute: ActivatedRoute) {}

  ngOnInit() {
    this.notificationList = []

    this.router.events
      .pipe(filter(event => event instanceof NavigationEnd))  // Filtramos solo los eventos de finalización de navegación
      .subscribe(async () => {
        //Check if the user is logged
        const logged = await isLogged()
        const routeTitle = this.getTitle();

        if (!logged) {
          if (routeTitle !== "login" && routeTitle !== "signup") {
            this.router.navigate(["/login"])
          }

        } else {
        }

      });
  }

  notificationError(message: string) {
    this.nNotifications += 1

    const newMessage = {
      id: this.nNotifications,
      message: message,
      type: "error"
    }

    console.log(this.notificationList)

    this.notificationList.push(newMessage)

    setTimeout(() => {
      this.notificationList = this.notificationList.filter(not => not.id != newMessage.id)
    }, 3000);

  }

  // Función que recorre las rutas activas y obtiene el título
  private getTitle(): string {
    let route = this.activatedRoute.root;  // Obtenemos la raíz de la ruta actual
    while (route.firstChild) {
      route = route.firstChild;  // Navegamos hasta la ruta activa más profunda
    }
    const title = route.snapshot.data['title'];  // Accedemos al título desde los datos de la ruta
    console.log('Title de la ruta:', title);  // Hacemos el log del título

    return title
  }
}
