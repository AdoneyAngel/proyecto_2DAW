import axios from "axios"
import { apiUrl, prefix } from "./config"

async function get(url:string, params:{name:any, value:any}[] = [], config:any = {withCredentials: true}) {
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
      method: "GET"
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

export async function isLogged() {
  return await get("isLogged")
}

export async function login(email: string, password: string) {
  return await axios.post(`${apiUrl}/login`, {email, password}, {
    headers: {
      "Content-Type": "application/jsons",
    },
    withCredentials: true
  })
  .then(res => {
    return res.data

  })
  .catch(err => {
    if (err.response.data.error) {
      return err.response.data

    }else {
      return {
        success: false,
        error: "Server error"
      }
    }
  })
}

export async function signup(username:string, email:string, password:string) {
  return await axios.post(`${apiUrl}/signup`, {username, email, password}, {
    headers: {
      "Content-Type": "application/jsons"
    },
    withCredentials: true
  })
  .then(res => {
    return res.data

  })
  .catch(err => {
    if (err.response.data.error) {
      return err.response.data

    }else {
      return {
        success: false,
        error: "Server error"
      }
    }
  })
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

export async function getIncludedProjects(members:boolean = false, owner:boolean = false) {
  return await get("users/0/includedProyects", [
    {
      name: "members",
      value: members
    },
    {
      name: "owner",
      value: owner
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

export async function getProjects(members:boolean = false, owner:boolean = false) {
  return await get(`users/0/proyects`, [
    {
      name: "members",
      value: members
    },
    {
      name: "owner",
      value: owner
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

export async function getProject(projectId:number|string, members:boolean = false, owner:boolean = false) {
  return await get(`proyects/${projectId}`, [
    {
      name: "members",
      value: members
    },
    {
      name: "owner",
      value: owner
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

export async function createTask(projectId:number|string, title:string, description:string, time:number, priority:number, tag:string, users:any = []) {
  return await post(`tasks`, {
    title, description, time, priority, tag, users, projectId
  })
}

export async function getTags(projectId:number|string) {
  return await get(`proyects/${projectId}/tags`)
}
