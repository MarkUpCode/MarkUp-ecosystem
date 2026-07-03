"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { Menu, X } from "lucide-react";
import { cn } from "@/lib/utils";
import { navigation, siteConfig } from "@/lib/constants";

export function Navbar() {
  const [open, setOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 20);
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  return (
    <header
      className={cn(
        "fixed top-0 inset-x-0 z-50 h-[72px] bg-obsidian transition-all duration-200",
        scrolled
          ? "border-b border-white/10 shadow-md shadow-black/30"
          : "border-b border-transparent"
      )}
    >
      <div className="max-w-[1200px] mx-auto h-full px-6 lg:px-10 flex items-center justify-between">
        {/* Logo */}
        <Link href="/" className="flex items-baseline gap-1.5 shrink-0">
          <span className="font-display text-[17px] font-semibold text-bone tracking-tight">
            Markup
          </span>
          <span className="font-serif text-[17px] italic text-gold">Business</span>
        </Link>

        {/* Desktop nav */}
        <nav className="hidden md:flex items-center gap-7">
          {navigation.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className="text-sm text-gray-400 hover:text-bone transition-colors tracking-wide"
            >
              {item.label}
            </Link>
          ))}
        </nav>

        {/* CTA */}
        <a
          href={`mailto:${siteConfig.email}`}
          className="hidden md:inline-flex items-center h-9 px-4 rounded-lg border border-white/20 text-bone text-sm hover:border-white/40 hover:bg-white/5 transition-all"
        >
          Contacto
        </a>

        {/* Mobile toggle */}
        <button
          type="button"
          aria-label={open ? "Cerrar menú" : "Abrir menú"}
          className="md:hidden p-1 text-bone"
          onClick={() => setOpen((v) => !v)}
        >
          {open ? <X className="size-5" /> : <Menu className="size-5" />}
        </button>
      </div>

      {/* Mobile menu */}
      {open && (
        <div className="md:hidden absolute top-full inset-x-0 bg-obsidian border-t border-white/10 px-6 py-5 flex flex-col gap-1">
          {navigation.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className="text-sm text-gray-400 hover:text-bone transition-colors py-2"
              onClick={() => setOpen(false)}
            >
              {item.label}
            </Link>
          ))}
          <div className="mt-3 pt-3 border-t border-white/10">
            <a
              href={`mailto:${siteConfig.email}`}
              className="flex items-center justify-center h-10 rounded-lg border border-white/20 text-bone text-sm w-full"
            >
              Contacto
            </a>
          </div>
        </div>
      )}
    </header>
  );
}
