import type { Metadata } from "next";
import { Fraunces, Inter, Inter_Tight } from "next/font/google";
import "./globals.css";
import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";

const fraunces = Fraunces({
  variable: "--font-fraunces",
  subsets: ["latin"],
  display: "swap",
});

const interTight = Inter_Tight({
  variable: "--font-inter-tight",
  subsets: ["latin"],
  display: "swap",
});

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
  display: "swap",
});

export const metadata: Metadata = {
  title: "Markup Business — Holding fintech del crédito cooperativo",
  description:
    "Construimos el futuro del crédito cooperativo en América Latina. Tres productos, una visión: Dinerop, Waki y Markup Digital.",
  keywords: [
    "fintech",
    "cooperativas",
    "crédito",
    "Dinerop",
    "Waki",
    "Markup Business",
    "consultoría digital",
  ],
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es" className="scroll-smooth">
      <body
        className={`${fraunces.variable} ${interTight.variable} ${inter.variable} font-sans antialiased`}
      >
        <Navbar />
        <main className="pt-[72px]">{children}</main>
        <Footer />
      </body>
    </html>
  );
}
