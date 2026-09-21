export const cooperativesData = [
  {
    id: 1,
    nombre: "Cooperativa de Ahorro y Crédito Unión",
    ciudad: "Quito",
    provincia: "Pichincha",
    direccion: "Av. Amazonas 123",
    telefono: "0999999999",
    paginaWeb: "https://example.com",
    logoUrl: "",
    calificacion: 4.8,
  },
  {
    id: 2,
    nombre: "Cooperativa del Valle",
    ciudad: "Cuenca",
    provincia: "Azuay",
    direccion: "Calle Larga 456",
    telefono: "0988888888",
    paginaWeb: "https://example.com",
    logoUrl: "",
    calificacion: 4.6,
  },
  {
    id: 3,
    nombre: "Cooperativa Andina",
    ciudad: "Guayaquil",
    provincia: "Guayas",
    direccion: "Av. 9 de Octubre 789",
    telefono: "0977777777",
    paginaWeb: "https://example.com",
    logoUrl: "",
    calificacion: 4.7,
  },
] satisfies Array<{
  id: number;
  nombre: string;
  ciudad: string;
  provincia: string;
  direccion: string;
  telefono: string;
  paginaWeb: string;
  logoUrl: string;
  calificacion: number;
}>;
