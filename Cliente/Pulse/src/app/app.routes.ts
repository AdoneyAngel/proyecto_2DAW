import { Routes } from '@angular/router';
import { DashboardComponent } from './view/dashboard/dashboard.component';
import { LoginComponent } from './view/login/login.component';
import { SignupComponent } from './view/signup/signup.component';
import { RackComponent } from './view/rack/rack.component';
import { ProjectsComponent } from './view/projects/projects.component';
import { ProjectComponent } from './view/projects/project/project.component';
import { CreateTaskComponent } from './view/projects/project/create-task/create-task.component';
import { TaskComponent } from './view/task/task.component';
import { MemberComponent } from './view/member/member.component';
import { NotFoundComponent } from './view/not-found/not-found.component';
import { IssuesComponent } from './view/issues/issues.component';

const dashboardRoutes = {
  path: "dashboard",
  data: {title: "dashboard"},
  loadComponent: () => DashboardComponent,
  children: [
    {
      path: "issues",
      data: {title: "issues"},
      loadComponent: () => IssuesComponent
    },
    {
      path: "rack",
      data: {title: "rack"},
      loadComponent: () => RackComponent
    },
    {
      path: "projects",
      data: {title: "all projects"},
      loadComponent: () => ProjectsComponent
    },
    {
      path: "projects/:id",
      data: {title: "project"},
      loadComponent: () => ProjectComponent,
      children: [
        {
          path: "tasks/:id",
          data: {title: "task"},
          loadComponent: () => TaskComponent
        },
        {
          path: "issues/:id",
          data: {title: "issue"},
          loadComponent: () => TaskComponent
        },
        {
          path: "createTask",
          data: {title: "create task"},
          loadComponent: () => CreateTaskComponent
        },
        {
          path: "members/:memberId",
          data: {title: "member"},
          loadComponent: () => MemberComponent
        }
      ]
    }
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
  },
  {
    path: "**",
    data: {title: "dashboard"},
    loadComponent: () => NotFoundComponent
  }
];
