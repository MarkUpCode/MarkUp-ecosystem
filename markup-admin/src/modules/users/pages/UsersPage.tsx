import { useState } from "react";

import { UsersHeader } from "../components/UsersHeader";
import { UsersTable } from "../components/UsersTable";

import { useUsers } from "../hooks/useUsers";
import { UsersStats } from "../components/UsersStats";
import { UsersFilters } from "../components/UsersFilters";
import { InviteUserModal } from "../components/InviteUserModal";
import { ConfirmationModal } from "@/components/ui/ConfirmationModal";
import type { UserListItem } from "../types/user";

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

  } = useUsers();

  return (

    <div>

      <UsersHeader
        onInvite={() => setInviteOpen(true)}
      />

      <UsersStats
        total={users.length}
        active={users.filter(u => u.status === "ACTIVE").length}
        pending={users.filter(u => u.status === "PENDING_ACTIVATION").length}
        disabled={users.filter(u => u.status === "DISABLED").length}
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

        <UsersTable users={users} />

      )}

      <InviteUserModal

          open={inviteOpen}

          loading={loading}

          onClose={() => setInviteOpen(false)}

          onSubmit={createUser}

      />

    </div>

  );

}