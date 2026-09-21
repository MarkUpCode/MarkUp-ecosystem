import { httpClient } from "../httpClient";

type LoginResponse = {
  accessToken: string;
  user: Record<string, unknown>;
};

type RegistrationStartPayload = {
  email: string;
  firstName: string;
  lastName: string;
  identification: string;
  phone?: string;
  province?: string;
  city?: string;
};

type RegistrationOtpVerifyPayload = {
  email: string;
  code: string;
};

type RegistrationPasswordPayload = {
  email: string;
  password: string;
};

export const loginRequest = async (email: string, password: string) => {
  return httpClient<LoginResponse>("/api/auth/login", {
    method: "POST",
    body: { email, password },
    auth: false,
  });
};

export async function activateAccount(token: string) {
  return httpClient(`/api/auth/activate?token=${encodeURIComponent(token)}`, {
    method: "GET",
    auth: false,
  });
}

export async function completeRegistration(payload: {
  email: string;
  password: string;
}) {
  return httpClient("/api/auth/complete-registration", {
    method: "POST",
    body: payload,
    auth: false,
  });
}

export async function startRegistrationOtp(payload: RegistrationStartPayload) {
  return httpClient<{ email: string; message: string; requiresVerification: boolean }>(
    "/api/auth/registration/start",
    {
      method: "POST",
      body: payload,
      auth: false,
    },
  );
}

export async function verifyRegistrationOtp(payload: RegistrationOtpVerifyPayload) {
  return httpClient<string>("/api/auth/registration/verify-code", {
    method: "POST",
    body: payload,
    auth: false,
  });
}

export async function resendRegistrationOtp(email: string) {
  return httpClient<{ email: string; message: string; requiresVerification: boolean }>(
    "/api/auth/registration/resend-code",
    {
      method: "POST",
      body: { email },
      auth: false,
    },
  );
}

export async function changeRegistrationEmail(payload: RegistrationStartPayload) {
  return httpClient<{ email: string; message: string; requiresVerification: boolean }>(
    "/api/auth/registration/change-email",
    {
      method: "POST",
      body: payload,
      auth: false,
    },
  );
}

export async function setRegistrationPassword(payload: RegistrationPasswordPayload) {
  return httpClient<string>("/api/auth/registration/set-password", {
    method: "POST",
    body: payload,
    auth: false,
  });
}

export async function forgotPassword(email: string) {
  return httpClient("/api/auth/password/forgot", {
    method: "POST",
    auth: false,
    body: { email },
  });
}

export async function resetPassword(payload: {
  token: string;
  newPassword: string;
}) {
  return httpClient("/api/auth/password/reset", {
    method: "POST",
    auth: false,
    body: payload,
  });
}
