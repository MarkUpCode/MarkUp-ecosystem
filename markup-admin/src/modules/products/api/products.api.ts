import { api } from "@/services/axios";

export type ProductType = "CREDIT" | "INVESTMENT";
export type CreditProductCategory = "CONSUMO" | "MICROCREDITO";
export interface ProductCondition {
  id?: number;
  minimumAmount: number;
  maximumAmount: number;
  minimumTermMonths: number;
  maximumTermMonths: number;
  annualRate: number;
  validFrom: string;
  validUntil?: string | null;
}
export interface FinancialProduct {
  id: number;
  cooperativeId: number;
  type: ProductType;
  creditCategory: CreditProductCategory | null;
  name: string;
  description?: string;
  minimumAmount: number;
  maximumAmount: number;
  active: boolean;
  conditions: ProductCondition[];
}
export type FinancialProductRequest = Omit<FinancialProduct, "id" | "cooperativeId" | "conditions"> & { conditions?: ProductCondition[] };

export async function getProducts(cooperativeId: number) {
  const { data } = await api.get<FinancialProduct[]>(`/api/admin/cooperatives/${cooperativeId}/products`);
  if (!Array.isArray(data)) throw new Error("El servidor devolvió una respuesta de productos inválida.");
  return data.map((product) => ({ ...product, conditions: Array.isArray(product.conditions) ? product.conditions : [] }));
}
export async function createProduct(cooperativeId: number, request: FinancialProductRequest) {
  const { data } = await api.post<FinancialProduct>(`/api/admin/cooperatives/${cooperativeId}/products`, request);
  return data;
}
export async function updateProduct(cooperativeId: number, productId: number, request: FinancialProductRequest) {
  const { data } = await api.put<FinancialProduct>(`/api/admin/cooperatives/${cooperativeId}/products/${productId}`, request);
  return data;
}
export async function addProductCondition(cooperativeId: number, productId: number, condition: ProductCondition) {
  const { data } = await api.post<ProductCondition>(`/api/admin/cooperatives/${cooperativeId}/products/${productId}/conditions`, condition);
  return data;
}
export async function addProductConditions(cooperativeId: number, productId: number, conditions: ProductCondition[]) {
  const { data } = await api.post<ProductCondition[]>(`/api/admin/cooperatives/${cooperativeId}/products/${productId}/conditions/batch`, conditions);
  return data;
}
