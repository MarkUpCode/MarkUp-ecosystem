import { httpClient } from "./httpClient";

export type CreditCategory = "CONSUMO" | "MICROCREDITO";
export type PublicCreditOffer = {
  cooperativeId: number;
  cooperativeName: string;
  productId: number;
  productName: string;
  description?: string | null;
  creditCategory: CreditCategory;
  amount: number;
  termMonths: number;
  annualRate: number;
  conditions: string;
};

export function getPublicCreditOffers(category: CreditCategory, amount: number, termMonths: number) {
  const params = new URLSearchParams({ creditCategory: category, amount: String(amount), termMonths: String(termMonths) });
  return httpClient<PublicCreditOffer[]>(`/api/credits/public-offers?${params.toString()}`, { auth: false });
}
