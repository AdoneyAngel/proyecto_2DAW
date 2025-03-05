import { Routes } from '@angular/router';
import { DashboardComponent } from './view/dashboard/dashboard.component';
import { LoginComponent } from './view/login/login.component';
import { SignupComponent } from './view/signup/signup.component';
import { RackComponent } from './view/rack/rack.component';
import { ProjectsComponent } from './view/projects/projects.component';

const dashboardRoutes = {
  path: "dashboard",
  data: {title: "dashboard"},
  loadComponent: () => DashboardComponent,
  children: [
    {
      path: "rack",
      data: {title: "rack"},
      loadComponent: () => RackComponent
    },
    {
      path: "projects",
      data: {title: "projects"},
      loadComponent: () => ProjectsComponent
    },
    // {
    //   path: "proyects/:id",
    //   title: "Proyects",
    //   // loadComponent: () =>,
    //   children: [
    //     {
    //       path: "tasks",
    //       title: "Tasks",
    //       // loadComponent: () =>,
    //     },
    //     {
    //       path: "taks/:id",
    //       title: "Tasks",
    //       // loadComponent: () =>,
    //       children: [
    //         {
    //           path: "users",
    //           title: "Task users",
    //           // loadComponent: () => ,
    //         }
    //       ]
    //     },
    //     {
    //       path: "issues",
    //       title: "Issues",
    //       // loadComponent: () =>,
    //     },
    //     {
    //       path: "issues/:id",
    //       title: "Issues",
    //       // loadComponent: () =>,
    //       children: [
    //         {
    //           path: "users",
    //           title: "Issue users",
    //           // loadComponent: () => ,
    //         }
    //       ]
    //     },
    //     {
    //       path: "members",
    //       title: "Members",
    //       // loadComponent: () =>,
    //     },
    //     {
    //       path: "members/:id",
    //       title: "Members",
    //       // loadComponent: () =>,
    //     }
    //   ]
    // }
  ]
}

export const routes: Routes = [
  dashboardRoutes,
  {
    path: "",
    redirectTo: "dashboard",
    pathMatch: "full"
  },
  {
    path: "login",
    data: {title: "login"},
    loadComponent: () => LoginComponent
  },
  {
    path: "signup",
    data: {title: "signup"},
    loadComponent: () => SignupComponent
  }
];
