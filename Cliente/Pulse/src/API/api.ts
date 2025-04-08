import axios from "axios"
import { apiUrl, prefix } from "./config"
import UserTaskStatusEnum from "../app/enums/UserTaskStatusEnum"

async function get(url:string, params:{name:any, value:any}[] = [], config:any = {withCredentials: true}, data:any = {}) {
  let requestPath = `${apiUrl}/${prefix}/${url}`

  if (params.length) requestPath += "?"

  params.map((actualParam, index) => {
    if (index) {
      requestPath += `&`
    }

    requestPath += `${actualParam.name}=${actualParam.value}`
  })

  try {
    const res = await axios({
      url: requestPath,
      withCredentials: true,
      method: "GET",
      data
    })

    if (res.data) {
      return res.data

    } else {
      return {
        success: false,
        error: "Server error"
      }
    }

  } catch (err: any) {
    if (err.response.data) {
      return err.response.data

    } else {
      return {
        success: false,
        error: "Server error"
      }
    }
  }


}

async function put(url:string, data:any = {}, params:{name:any, value:any}[] = [], config:any = {withCredentials: true}) {
  let requestPath = `${apiUrl}/${prefix}/${url}`

  if (params.length) requestPath += "?"

  params.map((actualParam, index) => {
    if (index) {
      requestPath += `&`
    }

    requestPath += `${actualParam.name}=${actualParam.value}`
  })

  try {
    const res = await axios({
      url: requestPath,
      withCredentials: true,
      method: "PUT",
      data
    })

    if (res.data) {
      return res.data

    } else {
      return {
        success: false,
        error: "Server error"
      }
    }

  } catch (err: any) {
    if (err.response.data) {
      return err.response.data

    } else {
      return {
        success: false,
        error: "Server error"
      }
    }
  }
}

async function post(url:string, data:any = {}, params:{name:any, value:any}[] = [], config:any = {withCredentials: true}) {
  let requestPath = `${apiUrl}/${prefix}/${url}`

  if (params.length) requestPath += "?"

  params.map((actualParam, index) => {
    if (index) {
      requestPath += `&`
    }

    requestPath += `${actualParam.name}=${actualParam.value}`
  })

  try {
    const res = await axios({
      url: requestPath,
      withCredentials: true,
      method: "POST",
      data,
      ...config
    })

    if (res.data) {
      return res.data

    } else {
      return {
        success: false,
        error: "Server error"
      }
    }

  } catch (err: any) {
    if (err.response.data) {
      return err.response.data

    } else {
      return {
        success: false,
        error: "Server error"
      }
    }
  }
}

async function remove(url:string, data:any = {}, params:{name:any, value:any}[] = [], config:any = {withCredentials: true}) {
  let requestPath = `${apiUrl}/${prefix}/${url}`

  if (params.length) requestPath += "?"

  params.map((actualParam, index) => {
    if (index) {
      requestPath += `&`
    }

    requestPath += `${actualParam.name}=${actualParam.value}`
  })

  try {
    const res = await axios({
      url: requestPath,
      withCredentials: true,
      method: "DELETE",
      data,
      ...config
    })

    if (res.data) {
      return res.data

    } else {
      return {
        success: false,
        error: "Server error"
      }
    }

  } catch (err: any) {
    if (err.response.data) {
      return err.response.data

    } else {
      return {
        success: false,
        error: "Server error"
      }
    }
  }
}

export async function isLogged() {
  return await get("isLogged")
}

export async function login(email: string, password: string) {
  return await post("login", {email, password})
}

export async function signup(username:string, email:string, password:string) {
  return await post("signup", {username, email, password})
}

export async function getInvitations() {
  return await get('users/0/pendingRequests', [
    {
      name:"proyect",
      value: true
    },
    {
      name: "owner",
      value: true
    }
  ])
}

export async function acceptInvitation(proyectId:number|string) {
  return await put(`acceptRequest/${proyectId}`)
}

export async function rejectInvitation(proyectId:number|string) {
  return await put(`rejectRequest/${proyectId}`)
}

export async function getIncludedProjects(members:boolean = false, owner:boolean = false, tasks:boolean = false, issues:boolean = false, tasksUsers:boolean = false) {
  return await get("users/0/includedProyects", [
    {
      name: "members",
      value: members
    },
    {
      name: "owner",
      value: owner
    },
    {
      name: "tasks",
      value: tasks
    },
    {
      name: "issues",
      value: issues
    },
    {
      name: "users",
      value: tasksUsers
    }
  ])
}

export async function getUserPhoto(userId:number|string) {
  const date = new Date()

  const res = await axios({
    url: `${apiUrl}/${prefix}/users/${userId}/photo?d=${date.getTime()}`,
    responseType: "blob",
    method: "GET",
    headers: {
      Accept: "image/png, image/jpg, image/svg, image/jpeg"
    },
    withCredentials: true
  })

  if (!res.data.size) return null;

  return URL.createObjectURL(res.data)
}

export async function getRackOfProyect(proyectId:number|string) {
  return await get(`proyects/${proyectId}/unassignedTasks`, [{
    name: "proyect",
    value: true
  }])
}

export async function getProjects(members:boolean = false, owner:boolean = false, tasks:boolean = false, issues:boolean = false, taskUsers:boolean = false) {
  return await get(`users/0/proyects`, [
    {
      name: "members",
      value: members
    },
    {
      name: "owner",
      value: owner
    },
    {
      name: "tasks",
      value: tasks
    },
    {
      name: "issues",
      value: issues
    },
    {
      name: "users",
      value: taskUsers
    }
  ])
}

export async function getTaskOfProject(projectId:string|number, project:boolean = false, users:boolean = false) {
  return await get(`proyects/${projectId}/tasks`, [{
    name: "proyect",
    value: project
  },
  {
    name: "users",
    value: users
  }])
}

export async function getProject(projectId:number|string, members:boolean = false, owner:boolean = false, tasks:boolean = false) {
  return await get(`proyects/${projectId}`, [
    {
      name: "members",
      value: members
    },
    {
      name: "owner",
      value: owner
    },
    {
      name: "tasks",
      value: tasks
    }
  ])
}

export async function updateProjectTitle(projectId:number|string, newTitle:string, members:boolean = false, owner:boolean = false) {
  return await put(`proyects/${projectId}`, {title:newTitle}, [
    {
      name: "memebrs",
      value: members
    },
    {
      name: "owner",
      value: owner
    }
  ])
}

export async function getProjectTasks(projectId:number|string, users:boolean = false) {
  return await get(`proyects/${projectId}/tasks`, [
    {
      name: "users",
      value: users
    }
  ])
}

export async function createTask(projectId:number|string, title:string, description:string = "", time:number, priority:number, tag:string, users:any = []) {
  return await post(`tasks`, {
    title, description, time, priority, tag, users, proyectId:projectId
  })
}

export async function updateTask(taskId:number|string, title:string, description:string = "", time:number, priority:number, tag:string, users:any = null) {
  return put(`tasks/${taskId}`, {
    title,
    description,
    time,
    priority,
    tag,
    users
  })
}

export async function getTags(projectId:number|string) {
  return await get(`proyects/${projectId}/tags`)
}

export async function getTask(taskId:number|string, users:boolean = false, project:boolean = false) {
  return await get(`tasks/${taskId}`, [
    {
      name: "users",
      value: users
    },
    {
      name: "proyect",
      value: project
    }
  ])
}

export async function getProjectMembers(projectId:number|string) {
  return await get(`proyects/${projectId}/members`)
}

export async function removeUserFromTask(taskId:number|string, userId:number|string) {
  return await remove(`tasks/${taskId}/users/${userId}`)
}

export async function searchUser(userInfo:string) {
  return await get("searchUser", [
    {
      name: "info",
      value: userInfo
    }
  ])
}

export async function getUser(userId:string|number) {
  return await get(`users/${userId}`)
}

export async function addUserToProyect(projectId:string|number, userId:string|number) {
  return await post(`proyects/${projectId}/members`, {userId})
}

export async function changeUserStatus(taskId:number|string, userId:number|string, newStatus:UserTaskStatusEnum) {
  return await put(`tasks/${taskId}/users/${userId}`, {status:newStatus})
}

export async function removeMemberFromProject(projectId:number|string, userId:number|string) {
  return await remove(`proyects/${projectId}/members/${userId}`)
}

export async function getMember(projectId:number|string, userId:number|string) {
  return await get(`proyects/${projectId}/members/${userId}`)
}

export async function updateMember(projectId:number|string, memberId:number|string, data:any) {
  return put(`proyects/${projectId}/members/${memberId}`, data)
}

export async function getIssuesOfProject(projectId:string|number, project:boolean = false, users:boolean = false) {
  return await get(`proyects/${projectId}/issues`, [
    {
      name: "proyect",
      value: project
    },
    {
      name: "users",
      value: users
    }
  ])
}

export async function deleteTask(taskId:number|string) {
  return await remove(`tasks/${taskId}`)
}

export async function getIssues(notifier:boolean = false) {
  return await get('issues', [
    {
      name: "notifier",
      value: notifier
    }
  ])
}

export async function getIssue(issueId:number|string, project:boolean = false, users:boolean = false) {
  return await get(`issues/${issueId}`, [
    {
      name: "proyect",
      value: project
    },
    {
      name: "users",
      value: users
    }
  ])
}

export async function updateIssue(issueId:number|string, title:string, description:string = "", time:number, priority:number, tag:string, users:any = null) {
  return await put(`issues/${issueId}`, {
    title,
    description,
    time,
    priority,
    tag,
    users
  })
}

export async function createIssue(projectId:number|string, title:string, description:string = "", time:number, priority:number, tag:string, users:any = []) {
  return await post(`issues`, {
    proyectId: projectId,
    title,
    description,
    time,
    priority,
    tag,
    users
  })
}

export async function deleteIssue(issueId:number|string) {
  return await remove(`issues/${issueId}`)
}

export async function updateUser(username:string|null, email:string|null) {
  return await put(`users/0`, {
    username,
    email
  })
}

export async function uploadProfilePhoto(formData:FormData) {
  return await post("users/0/photo", formData)
}

export async function addGoogleAccount(token:string) {
  return await post("googleAccount", {
    token
  })
}

export async function checkGoogleAccount() {
  return await get("googleAccount")
}

export async function removeGoogleAccount() {
  return await remove("googleAccount")
}

export async function loginEmail(email:string) {
  return await post("loginEmail", {email})
}

export async function googleLogin(credential:string) {
  return await post("googleLogin", {token: credential})
}

export async function googleSignUp(username:string, email:string, credential:string) {
  return await post("signup", {username, email, googleToken: credential})
}

export async function checkUserPassword() {
  return await get("checkPassword");
}

export async function addUserPassword(password:string) {
  return await post("addPassword", {password})
}
