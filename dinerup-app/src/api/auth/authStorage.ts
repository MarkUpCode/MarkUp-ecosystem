import { AUTH_TOKEN_KEY, AUTH_USER_KEY } from "../config";

const LEGACY_TOKEN_KEYS = ["access_token", "accessToken", "token"] as const;

export type AuthUser = Record<string, unknown> & {
  role?: string;
  name?: string;
};

function normalizeToken(value: string) {
  let token = value.trim();

  if (token.startsWith('"') && token.endsWith('"')) {
    try {
      const parsed = JSON.parse(token);
      if (typeof parsed === "string") {
        token = parsed.trim();
      }
    } catch {
      return null;
    }
  }

  if (token.startsWith("Bearer ")) {
    token = token.slice("Bearer ".length).trim();
  }

  return token || null;
}

export function readStoredToken() {
  const storageKeys = [AUTH_TOKEN_KEY, ...LEGACY_TOKEN_KEYS];

  for (const key of storageKeys) {
    const value = localStorage.getItem(key);
    if (value) {
      const token = normalizeToken(value);
      if (!token) {
        continue;
      }

      if (key !== AUTH_TOKEN_KEY || token !== value) {
        localStorage.setItem(AUTH_TOKEN_KEY, token);
      }

      if (key !== AUTH_TOKEN_KEY) {
        localStorage.removeItem(key);
      }

      return token;
    }
  }

  return null;
}

export function readStoredUser() {
  const rawUser = localStorage.getItem(AUTH_USER_KEY);

  if (!rawUser || rawUser === "undefined" || rawUser === "null") {
    return null;
  }

  try {
    return JSON.parse(rawUser) as AuthUser;
  } catch {
    return null;
  }
}

export function storeAuthSession(token: string, user: AuthUser) {
  const normalizedToken = normalizeToken(token);
  if (!normalizedToken) {
    throw new Error("La respuesta de autenticacion contiene un token invalido.");
  }

  localStorage.setItem(AUTH_TOKEN_KEY, normalizedToken);
  localStorage.setItem(AUTH_USER_KEY, JSON.stringify(user));
}

export function storeAuthUser(user: AuthUser) {
  localStorage.setItem(AUTH_USER_KEY, JSON.stringify(user));
}

export function clearStoredAuth() {
  localStorage.removeItem(AUTH_TOKEN_KEY);
  localStorage.removeItem(AUTH_USER_KEY);

  for (const key of LEGACY_TOKEN_KEYS) {
    localStorage.removeItem(key);
  }
}

export function extractToken(payload: Record<string, unknown> | null | undefined) {
  const value =
    payload?.accessToken ??
    payload?.access_token ??
    payload?.token ??
    payload?.jwt ??
    null;

  return typeof value === "string" ? normalizeToken(value) : null;
}
