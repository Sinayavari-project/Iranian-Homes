'use client';

import Link from 'next/link';
import { useRouter, usePathname } from 'next/navigation';
import { useState } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';

export default function Header() {
  const router = useRouter();
  const pathname = usePathname();
  const currentLocale = pathname.startsWith('/fa') ? 'fa' : 'en';
  const [isOpen, setIsOpen] = useState(false);
  const { language } = useLanguage();

  const switchLanguage = (locale: string) => {
    const newPath = pathname.replace(/^\/[a-z]{2}/, `/${locale}`);
    router.push(newPath);
  };

  const handleLanguageChange = (locale: string) => {
    switchLanguage(locale);
    setIsOpen(false);
  };

  const navigationLinks = [
    { href: '/', label: 'Home' },
    { href: '/destinations', label: 'Destinations' },
    { href: '/properties', label: 'Properties' },
    { href: '/about', label: 'About Us' },
    { href: '/contact', label: 'Contact' },
  ];

  return (
    <header className="bg-white shadow-md fixed w-full top-0 z-50">
      <nav className="container mx-auto px-4 py-4">
        <div className="flex justify-between items-center">
          <Link href="/" className="text-2xl font-bold text-primary">
            Global Homes
          </Link>
          
          <div className="flex items-center space-x-8">
            <div className="hidden md:flex items-center space-x-2 border border-gray-200 rounded-lg p-1">
              <button
                onClick={() => switchLanguage('en')}
                className={`px-3 py-1 rounded-md text-sm ${
                  currentLocale === 'en' ? 'bg-primary text-white' : 'text-gray-600 hover:bg-gray-100'
                }`}
              >
                English
              </button>
              <button
                onClick={() => switchLanguage('fa')}
                className={`px-3 py-1 rounded-md text-sm ${
                  currentLocale === 'fa' ? 'bg-primary text-white' : 'text-gray-600 hover:bg-gray-100'
                }`}
              >
                فارسی
              </button>
            </div>
            
            <button
              onClick={() => setIsOpen(!isOpen)}
              className="md:hidden text-gray-600 hover:text-primary"
              aria-label="Toggle menu"
            >
              <svg
                className="w-6 h-6"
                fill="none"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                {isOpen ? (
                  <path d="M6 18L18 6M6 6l12 12" />
                ) : (
                  <path d="M4 6h16M4 12h16M4 18h16" />
                )}
              </svg>
            </button>

            <div className="hidden md:flex space-x-8">
              <Link href="/destinations" className="hover:text-primary transition-colors">
                Destinations
              </Link>
              <Link href="/properties" className="hover:text-primary transition-colors">
                All Properties
              </Link>
              <Link href="/list-property" className="hover:text-primary transition-colors">
                List Your Property
              </Link>
              <Link href="/login" className="hover:text-primary transition-colors">
                Login / Register
              </Link>
            </div>
          </div>
        </div>
        {isOpen && (
          <div className="absolute top-full left-0 right-0 bg-white shadow-lg p-4 md:hidden">
            <nav className="flex flex-col space-y-4">
              <Link
                href="/"
                className="text-gray-600 hover:text-primary transition-colors"
              >
                Home
              </Link>
              <Link
                href="/properties"
                className="text-gray-600 hover:text-primary transition-colors"
              >
                Properties
              </Link>
              <Link
                href="/about"
                className="text-gray-600 hover:text-primary transition-colors"
              >
                About
              </Link>
              <Link
                href="/contact"
                className="text-gray-600 hover:text-primary transition-colors"
              >
                Contact
              </Link>
              <div className="pt-2 border-t border-gray-200">
                <button
                  onClick={() => handleLanguageChange('en')}
                  className={`px-3 py-1 rounded-md text-sm ${
                    currentLocale === 'en' ? 'bg-primary text-white' : 'text-gray-600 hover:bg-gray-100'
                  }`}
                >
                  English
                </button>
                <button
                  onClick={() => handleLanguageChange('fa')}
                  className={`px-3 py-1 rounded-md text-sm ml-2 ${
                    currentLocale === 'fa' ? 'bg-primary text-white' : 'text-gray-600 hover:bg-gray-100'
                  }`}
                >
                  فارسی
                </button>
              </div>
            </nav>
          </div>
        )}
      </nav>
    </header>
  );
}