import { httpClient } from "./httpClient";

export type InvestmentAvailability = { termMonths: number[]; interestPaymentOptions: string[] };
export type InvestmentOffer = {
  cooperativeId: number; cooperativeName: string; cooperativeLogoUrl?: string | null;
  productId: number; conditionId: number; productName: string; description?: string | null;
  minimumTermMonths: number; maximumTermMonths: number; annualRate: number;
  validFrom: string; validUntil?: string | null; interestPaymentOptions: string[];
  estimatedInterest?: number | null; estimatedTotal?: number | null;
  calculationMethod: string; renewalConditions?: string | null;
  earlyCancellationConditions?: string | null; targetAudience?: string | null;
};
export type InvestmentRequest = {
  id: number; cooperativeName: string; productName: string; amount: number; termMonths: number;
  interestPaymentOption?: string | null; annualRate: number; estimatedInterest?: number | null;
  estimatedTotal?: number | null; status: string; statusNote?: string | null; createdAt: string;
  clientName?: string | null; clientEmail?: string | null; clientPhone?: string | null;
};
export type FinancialProduct = { id: number; name: string; description?: string | null; minimumAmount: number; maximumAmount: number; active: boolean; conditions: Array<{ id: number; minimumTermMonths: number; maximumTermMonths: number; annualRate: number; validFrom: string; validUntil?: string | null }>; interestPaymentOptions: string[]; calculationMethod: string; renewalConditions?: string | null; earlyCancellationConditions?: string | null; targetAudience?: string | null };
const coop = "/api/credits/cooperative/me";
export const getInvestmentAvailability = (amount: number, termMonths?: number) => httpClient<InvestmentAvailability>(`/api/investments/availability?amount=${amount}${termMonths ? `&termMonths=${termMonths}` : ""}`, { auth: false });
export const getInvestmentOffers = (amount: number, termMonths: number, interestPaymentOption?: string) => httpClient<InvestmentOffer[]>(`/api/investments/offers?amount=${amount}&termMonths=${termMonths}${interestPaymentOption ? `&interestPaymentOption=${interestPaymentOption}` : ""}`, { auth: false });
export const createInvestmentRequest = (data: { productId: number; conditionId: number; amount: number; termMonths: number; interestPaymentOption?: string | null; personalDataConsent: true }) => httpClient<InvestmentRequest>("/api/investments/requests", { method: "POST", body: data });
export const getMyInvestmentRequests = () => httpClient<InvestmentRequest[]>("/api/investments/requests/me");
export const getCooperativeInvestmentProducts = () => httpClient<FinancialProduct[]>(`${coop}/investment-products`);
export const saveCooperativeInvestmentProduct = (data: Record<string, unknown>, id?: number) => httpClient<FinancialProduct>(`${coop}/investment-products${id ? `/${id}` : ""}`, { method: id ? "PUT" : "POST", body: data });
export const addInvestmentRate = (productId: number, data: Record<string, unknown>) => httpClient<FinancialProduct["conditions"][number]>(`${coop}/investment-products/${productId}/conditions`, { method: "POST", body: data });
export const getCooperativeInvestmentRequests = () => httpClient<InvestmentRequest[]>(`${coop}/investment-requests`);
export const updateInvestmentRequest = (id: number, status: string, note: string) => httpClient<InvestmentRequest>(`${coop}/investment-requests/${id}/status`, { method: "PUT", body: { status, note } });
