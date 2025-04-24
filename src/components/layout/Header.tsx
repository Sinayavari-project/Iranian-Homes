'use client';

import Link from 'next/link';
import { useRouter, usePathname } from 'next/navigation';

export default function Header() {
  const router = useRouter();
  const pathname = usePathname();
  const currentLocale = pathname.startsWith('/fa') ? 'fa' : 'en';

  const switchLanguage = (locale: string) => {
    const newPath = pathname.replace(/^\/[a-z]{2}/, `/${locale}`);
    router.push(newPath);
  };

  return (
    <header className="bg-white shadow-md fixed w-full top-0 z-50">
      <nav className="container mx-auto px-4 py-4">
        <div className="flex justify-between items-center">
          <Link href="/" className="text-2xl font-bold text-primary">
            Iranian Homes
          </Link>
          
          <div className="flex items-center space-x-8">
            <div className="flex items-center space-x-2 border border-gray-200 rounded-lg p-1">
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
            
            <div className="hidden md:flex space-x-8">
              <Link href="/properties" className="hover:text-primary transition-colors">
                اقامتگاه‌ها
              </Link>
              <Link href="/villas" className="hover:text-primary transition-colors">
                ویلاها
              </Link>
              <Link href="/apartments" className="hover:text-primary transition-colors">
                آپارتمان‌ها
              </Link>
              <Link href="/login" className="hover:text-primary transition-colors">
                ورود / ثبت‌نام
              </Link>
            </div>
          </div>
        </div>
      </nav>
    </header>
  );
}