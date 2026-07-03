import { createContext, useEffect, useMemo, useState } from "react";
import type { ReactNode } from "react";
import { login as loginRequest } from "@/services/auth.service";
import {
  clearSession,
  getStoredSession,
  setStoredSession,
} from "@/services/session.service";
import { isAdminRole, type AuthState, type AuthUser } from "@/types/auth";

interface AuthContextValue extends AuthState {
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  refreshUser: (user: AuthUser) => void;
}

export const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<AuthUser | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const session = getStoredSession();
    if (session) {
      if (!isAdminRole(session.user.role)) {
        clearSession();
        setUser(null);
        setToken(null);
        setIsLoading(false);
        return;
      }
      setUser(session.user);
      setToken(session.token);
    }
    setIsLoading(false);
  }, []);

  const login = async (email: string, password: string) => {
    const response = await loginRequest({ email, password });

    if (!isAdminRole(response.user?.role)) {
      clearSession();
      throw new Error("Acceso denegado");
    }

    setStoredSession(response.accessToken, response.user);
    setUser(response.user);
    setToken(response.accessToken);
  };

  const logout = () => {
    clearSession();
    setUser(null);
    setToken(null);
  };

  const refreshUser = (nextUser: AuthUser) => {
    setUser(nextUser);
    if (token) {
      setStoredSession(token, nextUser);
    }
  };

  const value = useMemo(
    () => ({
      user,
      token,
      isLoading,
      isAuthenticated: Boolean(user && token),
      login,
      logout,
      refreshUser,
    }),
    [isLoading, token, user],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}
