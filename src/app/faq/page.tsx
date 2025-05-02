'use client';

import { useState } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import { Icon, Icons } from '@/components/shared/Icons';

interface FAQItem {
  question: {
    en: string;
    fa: string;
  };
  answer: {
    en: string;
    fa: string;
  };
}

const faqs: FAQItem[] = [
  {
    question: {
      en: 'How do I book a property?',
      fa: 'چگونه می‌توانم یک ملک را رزرو کنم؟'
    },
    answer: {
      en: 'You can book a property by clicking the "Reserve via WhatsApp" button on the property page. This will open a WhatsApp chat with our team who will assist you with the booking process.',
      fa: 'شما می‌توانید با کلیک روی دکمه "رزرو از طریق واتساپ" در صفحه ملک، یک چت واتساپ با تیم ما باز کنید که به شما در فرآیند رزرو کمک خواهد کرد.'
    }
  },
  {
    question: {
      en: 'What payment methods do you accept?',
      fa: 'چه روش‌های پرداختی را می‌پذیرید؟'
    },
    answer: {
      en: 'We accept various payment methods including bank transfers, credit cards, and cash payments. Our team will provide you with the available payment options during the booking process.',
      fa: 'ما روش‌های پرداخت مختلفی از جمله انتقال بانکی، کارت‌های اعتباری و پرداخت نقدی را می‌پذیریم. تیم ما گزینه‌های پرداخت موجود را در طول فرآیند رزرو به شما ارائه خواهد داد.'
    }
  },
  {
    question: {
      en: 'What is your cancellation policy?',
      fa: 'سیاست لغو رزرو شما چیست؟'
    },
    answer: {
      en: 'Our cancellation policy varies depending on the property and the time of cancellation. Generally, cancellations made more than 7 days before check-in will receive a full refund, while cancellations made within 7 days may be subject to a fee. Please check the specific cancellation policy for each property.',
      fa: 'سیاست لغو رزرو ما بسته به ملک و زمان لغو متفاوت است. به طور کلی، لغو رزرو بیش از ۷ روز قبل از ورود، بازپرداخت کامل دریافت می‌کند، در حالی که لغو در عرض ۷ روز ممکن است مشمول هزینه باشد. لطفاً سیاست لغو خاص هر ملک را بررسی کنید.'
    }
  },
  {
    question: {
      en: 'What are the check-in and check-out times?',
      fa: 'زمان ورود و خروج چه ساعتی است؟'
    },
    answer: {
      en: 'Standard check-in time is 3:00 PM and check-out time is 11:00 AM. Early check-in or late check-out may be available upon request and subject to availability.',
      fa: 'زمان ورود استاندارد ساعت ۳ بعد از ظهر و زمان خروج ساعت ۱۱ صبح است. ورود زودتر یا خروج دیرتر ممکن است در صورت درخواست و با توجه به موجودی امکان‌پذیر باشد.'
    }
  },
  {
    question: {
      en: 'Are pets allowed in the properties?',
      fa: 'آیا حیوانات خانگی در ملک‌ها مجاز هستند؟'
    },
    answer: {
      en: 'Pet policies vary by property. Some properties are pet-friendly while others are not. Please check the property details or contact our team for specific information about pets.',
      fa: 'سیاست‌های مربوط به حیوانات خانگی بسته به ملک متفاوت است. برخی از ملک‌ها مناسب حیوانات خانگی هستند در حالی که برخی دیگر نیستند. لطفاً جزئیات ملک را بررسی کنید یا با تیم ما تماس بگیرید تا اطلاعات خاصی در مورد حیوانات خانگی دریافت کنید.'
    }
  },
  {
    question: {
      en: 'What amenities are included in the properties?',
      fa: 'چه امکاناتی در ملک‌ها موجود است؟'
    },
    answer: {
      en: 'All our properties come with basic amenities including WiFi, air conditioning, and kitchen facilities. Additional amenities vary by property and are listed in the property details. Please check the specific amenities for each property before booking.',
      fa: 'همه ملک‌های ما دارای امکانات اولیه از جمله وای‌فای، تهویه مطبوع و امکانات آشپزخانه هستند. امکانات اضافی بسته به ملک متفاوت است و در جزئیات ملک ذکر شده است. لطفاً قبل از رزرو، امکانات خاص هر ملک را بررسی کنید.'
    }
  }
];

export default function FAQPage() {
  const { language } = useLanguage();
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  const toggleFAQ = (index: number) => {
    setOpenIndex(openIndex === index ? null : index);
  };

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-3xl mx-auto">
        <div className="text-center mb-12">
          <h1 className="text-3xl font-bold text-gray-900 mb-4">
            {language === 'en' ? 'Frequently Asked Questions' : 'سوالات متداول'}
          </h1>
          <p className="text-xl text-gray-600">
            {language === 'en' 
              ? 'Find answers to common questions about our properties and services' 
              : 'پاسخ سوالات رایج در مورد ملک‌ها و خدمات ما را بیابید'}
          </p>
        </div>

        <div className="space-y-4">
          {faqs.map((faq, index) => (
            <div key={index} className="bg-white rounded-lg shadow-md overflow-hidden">
              <button
                onClick={() => toggleFAQ(index)}
                className="w-full px-6 py-4 text-left focus:outline-none"
              >
                <div className="flex justify-between items-center">
                  <h3 className="text-lg font-medium text-gray-900">
                    {faq.question[language as keyof typeof faq.question]}
                  </h3>
                  <Icon 
                    icon={Icons.ChevronRight} 
                    size={20} 
                    className={`transform transition-transform duration-200 ${
                      openIndex === index ? 'rotate-90' : ''
                    }`}
                  />
                </div>
              </button>
              
              {openIndex === index && (
                <div className="px-6 pb-4">
                  <p className="text-gray-600">
                    {faq.answer[language as keyof typeof faq.answer]}
                  </p>
                </div>
              )}
            </div>
          ))}
        </div>

        <div className="mt-12 text-center">
          <p className="text-gray-600 mb-4">
            {language === 'en' 
              ? 'Still have questions? Contact us via WhatsApp' 
              : 'هنوز سوالی دارید؟ از طریق واتساپ با ما تماس بگیرید'}
          </p>
          <a
            href="https://wa.me/971506942198"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center justify-center gap-2 bg-green-500 text-white py-3 px-6 rounded-lg hover:bg-green-600 transition-colors"
          >
            <Icon icon={Icons.WhatsApp} size={24} />
            {language === 'en' ? 'Chat on WhatsApp' : 'چت در واتساپ'}
          </a>
        </div>
      </div>
    </div>
  );
} 