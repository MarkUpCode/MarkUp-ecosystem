import { useCallback, useEffect, useState } from "react";
import { useToast } from "@/hooks/useToast";

import {
  getUsers,
  inviteUser,
  changeUserStatus,
} from "../api/users.api";

import type {
  UserListItem,
  UsersPageResponse,
  InviteUserRequest,
} from "../types/user";

export function useUsers() {
  
  const toast = useToast();
  
  const [users, setUsers] = useState<UserListItem[]>([]);

  const [loading, setLoading] = useState(false);

  const [page, setPage] = useState(0);

  const [size] = useState(10);

  const [search, setSearch] = useState("");

  const [role, setRole] = useState("");

  const [status, setStatus] = useState("");

  const [totalPages, setTotalPages] = useState(0);

  const [totalElements, setTotalElements] = useState(0);

  const loadUsers = useCallback(async () => {
    try {
      setLoading(true);

      const response: UsersPageResponse =
        await getUsers(page, size);

      setUsers(response.content);

      setTotalPages(response.totalPages);

      setTotalElements(response.totalElements);

    } finally {
      setLoading(false);
    }
  }, [page, size]);

  useEffect(() => {
    loadUsers();
  }, [loadUsers]);

  const filteredUsers = users.filter((user) => {

    const matchesSearch =
        user.email.toLowerCase().includes(search.toLowerCase());

    const matchesRole =
        role === "" || user.role === role;

    const matchesStatus =
        status === "" || user.status === status;

    return (
        matchesSearch &&
        matchesRole &&
        matchesStatus
    );

    });

  const createUser = async (
    request: InviteUserRequest
    ) => {

    try {

        await inviteUser(request);

        toast.success(
        "Usuario invitado",
        "Se envió el correo de activación."
        );

        await loadUsers();

    } catch (error: any) {

        toast.error(
        "No se pudo invitar al usuario",
        error?.response?.data?.message ??
        "Ha ocurrido un error."
        );

        throw error;

    }

    };

  const updateStatus = async (
    id: number,
    active: boolean
  ) => {

    await changeUserStatus(id, { active });

    await loadUsers();

  };

  return {

    users: filteredUsers,

    loading,

    page,

    size,

    totalPages,

    totalElements,

    setPage,

    reload: loadUsers,

    createUser,

    updateStatus,

    search,

    role,

    status,

    setSearch,

    setRole,

    setStatus,

    

};
}