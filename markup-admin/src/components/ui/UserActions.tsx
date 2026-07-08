import {
  Eye,
  Lock,
  Unlock,
  MoreVertical,
} from "lucide-react";

import { IconButton } from "@/components/ui/icon-button";

interface UserActionsProps {

  active: boolean;

  onView?: () => void;

  onToggleStatus?: () => void;

}

export function UserActions({

  active,

  onView,

  onToggleStatus,

}: UserActionsProps) {

  return (

    <div className="flex justify-end gap-2">

      <IconButton
        onClick={onView}
      >
        <Eye className="h-4 w-4" />
      </IconButton>

      <IconButton
        variant={
          active
            ? "danger"
            : "success"
        }
        onClick={onToggleStatus}
      >
        {active ? (

          <Lock className="h-4 w-4" />

        ) : (

          <Unlock className="h-4 w-4" />

        )}
      </IconButton>

      <IconButton>

        <MoreVertical className="h-4 w-4" />

      </IconButton>

    </div>

  );

}