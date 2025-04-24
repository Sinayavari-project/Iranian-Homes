import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import Link from 'next/link'
import { useRouter, usePathname } from 'next/navigation'
import FloatingLanguageSwitcher from '@/components/common/FloatingLanguageSwitcher'
import Header from '@/components/layout/Header'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Iranian Homes - Find Your Perfect Home',
  description: 'Discover and book unique accommodations worldwide. Find villas, apartments, and vacation rentals.',
  keywords: 'homes, villas, apartments, vacation rentals, accommodation',
}

function Footer() {
  return (
    <footer className="bg-gray-800 text-white py-8">
      <div className="container mx-auto px-4">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <h3 className="text-lg font-semibold mb-4">درباره ما</h3>
            <p className="text-gray-300">
              Iranian Homes پلتفرم پیشرو در اجاره اقامتگاه‌های ایران
            </p>
          </div>
          <div>
            <h3 className="text-lg font-semibold mb-4">لینک‌های مفید</h3>
            <ul className="space-y-2">
              <li><Link href="/about" className="text-gray-300 hover:text-white">درباره ما</Link></li>
              <li><Link href="/contact" className="text-gray-300 hover:text-white">تماس با ما</Link></li>
              <li><Link href="/faq" className="text-gray-300 hover:text-white">سوالات متداول</Link></li>
            </ul>
          </div>
          <div>
            <h3 className="text-lg font-semibold mb-4">پشتیبانی</h3>
            <ul className="space-y-2">
              <li><Link href="/help" className="text-gray-300 hover:text-white">راهنمای استفاده</Link></li>
              <li><Link href="/privacy" className="text-gray-300 hover:text-white">حریم خصوصی</Link></li>
              <li><Link href="/terms" className="text-gray-300 hover:text-white">قوانین و مقررات</Link></li>
            </ul>
          </div>
          <div>
            <h3 className="text-lg font-semibold mb-4">تماس با ما</h3>
            <ul className="space-y-2">
              <li className="text-gray-300">تلفن: ۰۲۱-۸۸۸۸۸۸۸۸</li>
              <li className="text-gray-300">ایمیل: info@iranianhomes.com</li>
            </ul>
          </div>
        </div>
        <div className="border-t border-gray-700 mt-8 pt-8 text-center text-gray-300">
          <p>© {new Date().getFullYear()} Iranian Homes. تمامی حقوق محفوظ است.</p>
        </div>
      </div>
    </footer>
  )
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fa" dir="rtl">
      <body className={`${inter.className} min-h-screen flex flex-col`}>
        <Header />
        <main className="flex-grow pt-16">
          {children}
        </main>
        <Footer />
        <FloatingLanguageSwitcher />
      </body>
    </html>
  )
}