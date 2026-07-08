import { useState } from "react";

import { UsersHeader } from "../components/UsersHeader";
import { UsersTable } from "../components/UsersTable";

import { useUsers } from "../hooks/useUsers";
import { UsersStats } from "../components/UsersStats";
import { UsersFilters } from "../components/UsersFilters";
import { InviteUserModal } from "../components/InviteUserModal";
import { ConfirmationModal } from "@/components/ui/ConfirmationModal";
import type { UserListItem } from "../types/user";
import { UsersPagination } from "../components/UsersPagination";

export function UsersPage() {

  const [inviteOpen, setInviteOpen] = useState(false);

  const [selectedUser, setSelectedUser] =
  useState<UserListItem | null>(null);

  const [confirmOpen, setConfirmOpen] =
  useState(false);
  
  const {

      users,

      loading,

      createUser,

      search,

      role,

      status,

      setSearch,

      setRole,

      setStatus,

      reload,
      
      updateStatus,

      page,

      size,

      totalPages,

      totalElements,

      setPage,

      stats,


  } = useUsers();

  function handleToggleStatus(user: UserListItem) {

    setSelectedUser(user);

    setConfirmOpen(true);

  }

  return (

    <div>

      <UsersHeader
        onInvite={() => setInviteOpen(true)}
      />

      <UsersStats
          total={stats.total}
          active={stats.active}
          pending={stats.pending}
          disabled={stats.disabled}
      />

      <UsersFilters
          search={search}
          role={role}
          status={status}
          onSearchChange={setSearch}
          onRoleChange={setRole}
          onStatusChange={setStatus}
          onReload={reload}
      />

      {loading ? (

        <div className="rounded-3xl border border-white/10 bg-slate-900 p-20 text-center">

          Cargando usuarios...

        </div>

      ) : (

        <UsersTable
            users={users}
            onToggleStatus={handleToggleStatus}
            
        />

        

      )}
      
      <UsersPagination
          page={page}
          size={size}
          totalPages={totalPages}
          totalElements={totalElements}
          onPageChange={setPage}
      />

      <InviteUserModal

          open={inviteOpen}

          loading={loading}

          onClose={() => setInviteOpen(false)}

          onSubmit={createUser}

      />
      <ConfirmationModal
        open={confirmOpen}
        title={
            selectedUser?.active
                ? "Deshabilitar usuario"
                : "Habilitar usuario"
        }
        message={
            selectedUser?.active
                ? `¿Está seguro de deshabilitar a ${selectedUser.email}?`
                : `¿Está seguro de habilitar a ${selectedUser?.email}?`
        }
        danger={selectedUser?.active}
        confirmText={
            selectedUser?.active
                ? "Deshabilitar"
                : "Habilitar"
        }
        onClose={() => {
            setConfirmOpen(false);
            setSelectedUser(null);
        }}
        onConfirm={async () => {

            if (!selectedUser) return;

            await updateStatus(

                selectedUser.id,

                !selectedUser.active

            );

        }}
    />

    </div>

  );

}