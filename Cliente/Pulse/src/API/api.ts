import axios from "axios"
import { apiUrl, prefix } from "./config"

export async function isLogged() {
  return await axios.get(`${apiUrl}/${prefix}/isLogged`, {
    withCredentials: true
  })
  .then(res => {
    return res

  })
  .catch (err => {
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
  return await axios.get(`${apiUrl}/${prefix}/users/0/pendingRequests?proyect=true&owner=true`, {
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

export async function acceptInvitation(proyectId:number|string) {
  return await axios.put(`${apiUrl}/${prefix}/acceptRequest/${proyectId}`, {}, {
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

export async function rejectInvitation(proyectId:number|string) {
  return await axios.put(`${apiUrl}/${prefix}/rejectRequest/${proyectId}`, {}, {
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

export async function getIncludedProjects() {
  const res = await axios({
    url: `${apiUrl}/${prefix}/users/0/includedProyects?members=true`,
    method: "GET",
    withCredentials: true
  })

  if (res.data) {
    return res.data

  } else {
    return {
      success: false,
      error: "Server error"
    }
  }
}

export async function getUserPhoto(userId:number|string) {
  const res = await axios({
    url: `${apiUrl}/${prefix}/users/${userId}/photo`,
    responseType: "blob",
    method: "GET",
    headers: {
      Accept: "image/png, image/jpg, image/svg, image/jpeg"
    },
    withCredentials: true
  })

  console.log("USER: " + userId)

  if (!res.data.size) return null;

  console.log("SI")

  return URL.createObjectURL(res.data)
}
