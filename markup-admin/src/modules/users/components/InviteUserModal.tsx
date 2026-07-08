import { Modal } from "@/components/ui/modal";

import type { InviteUserRequest } from "../types/user";

import { InviteUserForm } from "./InviteUserForm";

interface InviteUserModalProps {

  open: boolean;

  loading?: boolean;

  onClose: () => void;

  onSubmit: (request: InviteUserRequest) => Promise<void>;

}

export function InviteUserModal({

  open,

  loading,

  onClose,

  onSubmit,

}: InviteUserModalProps) {

  async function handleSubmit(
    request: InviteUserRequest
  ) {

    await onSubmit(request);

    onClose();

  }

  return (

    <Modal

      open={open}

      title="Invitar usuario"

      description="Se enviará un correo con el enlace para activar la cuenta."

      onClose={onClose}

    >

      <InviteUserForm

        loading={loading}

        onSubmit={handleSubmit}

      />

    </Modal>

  );

}