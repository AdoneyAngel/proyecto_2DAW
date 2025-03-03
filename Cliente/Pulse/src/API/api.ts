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
    return false
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
    return err.response.data
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
    return err.response.data
  })
}
