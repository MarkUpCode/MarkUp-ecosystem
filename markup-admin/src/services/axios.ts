import axios from "axios";
import { API_BASE_URL } from "./api";
import { getToken, clearSession } from "./session.service";

export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

api.interceptors.request.use((config) => {
  const token = getToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error?.response?.status === 401) {
      clearSession();
      window.dispatchEvent(new Event("markup-admin-logout"));
    }
    return Promise.reject(error);
  },
);
