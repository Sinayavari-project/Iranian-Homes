'use client';

import Link from 'next/link';
import { useLanguage } from '@/contexts/LanguageContext';

export default function Header() {
  const { language } = useLanguage();

  const navigationLinks = [
    { href: '/properties', label: language === 'en' ? 'Properties' : 'اقامتگاه‌ها' },
    { href: '/about', label: language === 'en' ? 'About' : 'درباره ما' },
    { href: '/contact', label: language === 'en' ? 'Contact' : 'تماس با ما' },
  ];

  return (
    <header className="fixed top-0 left-0 right-0 bg-white shadow-md z-40">
      <div className="max-w-7xl mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <Link href="/" className="text-xl font-bold text-gray-800">
            {language === 'en' ? 'Global Homes' : 'خانه‌های جهانی'}
          </Link>
          <nav className={language === 'fa' ? 'font-arabic' : ''}>
            <ul className="hidden md:flex space-x-8">
              {navigationLinks.map((link) => (
                <li key={link.href}>
                  <Link href={link.href} className="text-gray-600 hover:text-gray-900">
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </nav>
        </div>
      </div>
    </header>
  );
}