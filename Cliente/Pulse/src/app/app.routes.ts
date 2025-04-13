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
import { CreateIssueComponent } from './view/issues/create-issue/create-issue.component';
import { ProfileComponent } from './view/profile/profile.component';
import { AddUserPasswordComponent } from './view/add-user-password/add-user-password.component';
import { MemberHistoryComponent } from './view/projects/project/member-history/member-history.component';
import { TaskHistoryComponent } from './view/task/task-history/task-history.component';

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
      path: "issues/createIssue",
      data: {title: "create issue"},
      loadComponent: () => CreateIssueComponent
    },
    {
      path: "profile",
      data: {title: "profile"},
      loadComponent: () => ProfileComponent
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
          path: "tasks/:id/history",
          data: {title: "taskHistory"},
          loadComponent: () => TaskHistoryComponent
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
        },
        {
          path: "memberHistory",
          data: {title: "memberHistory"},
          loadComponent: () => MemberHistoryComponent
        }
      ]
    }
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
    path: "addPassword",
    data: {title: "add password"},
    loadComponent: () => AddUserPasswordComponent
  },
  {
    path: "**",
    data: {title: "dashboard"},
    loadComponent: () => NotFoundComponent
  }
];
