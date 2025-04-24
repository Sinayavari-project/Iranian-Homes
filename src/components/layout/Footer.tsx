export default function Footer() {
    return (
      <footer className="bg-gray-900 text-white py-12">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            {/* Column 1 - About */}
            <div>
              <h3 className="text-lg font-bold mb-4">درباره Iranian Homes</h3>
              <ul className="space-y-2">
                <li><a href="/about" className="hover:text-blue-400">درباره ما</a></li>
                <li><a href="/contact" className="hover:text-blue-400">تماس با ما</a></li>
                <li><a href="/careers" className="hover:text-blue-400">فرصت‌های شغلی</a></li>
              </ul>
            </div>
  
            {/* Column 2 - Popular Destinations */}
            <div>
              <h3 className="text-lg font-bold mb-4">مقاصد محبوب</h3>
              <ul className="space-y-2">
                <li><a href="/properties/tehran" className="hover:text-blue-400">تهران</a></li>
                <li><a href="/properties/kish" className="hover:text-blue-400">کیش</a></li>
                <li><a href="/properties/ramsar" className="hover:text-blue-400">رامسر</a></li>
                <li><a href="/properties/shomal" className="hover:text-blue-400">شمال</a></li>
              </ul>
            </div>
  
            {/* Column 3 - Property Types */}
            <div>
              <h3 className="text-lg font-bold mb-4">انواع اقامتگاه</h3>
              <ul className="space-y-2">
                <li><a href="/villas" className="hover:text-blue-400">ویلا</a></li>
                <li><a href="/apartments" className="hover:text-blue-400">آپارتمان</a></li>
                <li><a href="/suites" className="hover:text-blue-400">سوئیت</a></li>
                <li><a href="/eco-lodges" className="hover:text-blue-400">بوم‌گردی</a></li>
              </ul>
            </div>
  
            {/* Column 4 - Support */}
            <div>
              <h3 className="text-lg font-bold mb-4">پشتیبانی</h3>
              <ul className="space-y-2">
                <li><a href="/help" className="hover:text-blue-400">راهنما</a></li>
                <li><a href="/faq" className="hover:text-blue-400">سوالات متداول</a></li>
                <li><a href="/rules" className="hover:text-blue-400">قوانین و مقررات</a></li>
              </ul>
            </div>
          </div>
  
          <div className="mt-8 pt-8 border-t border-gray-800 text-center">
            <p className="text-gray-400">
              © ۱۴۰۲ Iranian Homes - تمامی حقوق محفوظ است
            </p>
          </div>
        </div>
      </footer>
    );
  }