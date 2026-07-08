export type UserRole =
  | "ADMIN"
  | "CLIENT"
  | "COOPERATIVE";

export type UserStatus =
  | "ACTIVE"
  | "PENDING_ACTIVATION"
  | "DISABLED";

export interface UserListItem {
  id: number;
  email: string;
  role: UserRole;
  status: UserStatus;
  active: boolean;
  createdAt: string;
}

export interface UsersPageResponse {
  content: UserListItem[];

  page: number;
  size: number;

  totalElements: number;
  totalPages: number;

  first: boolean;
  last: boolean;
}

export interface InviteUserRequest {
  email: string;
  role: UserRole;
  cooperativaId?: number | null;
}

export interface ChangeStatusRequest {
  active: boolean;
}