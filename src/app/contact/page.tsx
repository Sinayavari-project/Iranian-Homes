'use client';

import { useState } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import { Icon, Icons } from '@/components/shared/Icons';

export default function ContactPage() {
  const { t, language } = useLanguage();
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    message: ''
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Here you would typically send the form data to your backend
    console.log('Form submitted:', formData);
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-12">
          <h1 className="text-3xl font-bold text-gray-900 mb-4">
            {language === 'en' ? 'Contact Us' : 'تماس با ما'}
          </h1>
          <p className="text-xl text-gray-600">
            {language === 'en' 
              ? 'Get in touch with us for any questions or inquiries' 
              : 'برای هرگونه سوال یا درخواست با ما در تماس باشید'}
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-12">
          {/* Contact Information */}
          <div className="bg-white rounded-lg shadow-lg p-8">
            <h2 className="text-2xl font-semibold mb-6">
              {language === 'en' ? 'Contact Information' : 'اطلاعات تماس'}
            </h2>
            
            <div className="space-y-6">
              <div className="flex items-start">
                <Icon icon={Icons.WhatsApp} size={24} className="text-green-500 mt-1" />
                <div className="ml-4">
                  <h3 className="text-lg font-medium">
                    {language === 'en' ? 'WhatsApp' : 'واتساپ'}
                  </h3>
                  <a 
                    href="https://wa.me/971506942198" 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="text-blue-600 hover:text-blue-800"
                  >
                    +971 50 694 2198
                  </a>
                </div>
              </div>

              <div className="flex items-start">
                <Icon icon={Icons.Location} size={24} className="text-primary mt-1" />
                <div className="ml-4">
                  <h3 className="text-lg font-medium">
                    {language === 'en' ? 'Location' : 'آدرس'}
                  </h3>
                  <p className="text-gray-600">
                    {language === 'en' 
                      ? 'Dubai, UAE' 
                      : 'دبی، امارات متحده عربی'}
                  </p>
                </div>
              </div>

              <div className="flex items-start">
                <Icon icon={Icons.Calendar} size={24} className="text-primary mt-1" />
                <div className="ml-4">
                  <h3 className="text-lg font-medium">
                    {language === 'en' ? 'Business Hours' : 'ساعات کاری'}
                  </h3>
                  <p className="text-gray-600">
                    {language === 'en' 
                      ? 'Monday - Friday: 9:00 AM - 6:00 PM' 
                      : 'شنبه تا پنجشنبه: ۹ صبح تا ۶ عصر'}
                  </p>
                </div>
              </div>
            </div>
          </div>

          {/* Contact Form */}
          <div className="bg-white rounded-lg shadow-lg p-8">
            <h2 className="text-2xl font-semibold mb-6">
              {language === 'en' ? 'Send us a Message' : 'پیام خود را ارسال کنید'}
            </h2>
            
            <form onSubmit={handleSubmit} className="space-y-6">
              <div>
                <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-1">
                  {language === 'en' ? 'Name' : 'نام'}
                </label>
                <input
                  type="text"
                  id="name"
                  name="name"
                  value={formData.name}
                  onChange={handleChange}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-primary focus:border-primary"
                />
              </div>

              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-1">
                  {language === 'en' ? 'Email' : 'ایمیل'}
                </label>
                <input
                  type="email"
                  id="email"
                  name="email"
                  value={formData.email}
                  onChange={handleChange}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-primary focus:border-primary"
                />
              </div>

              <div>
                <label htmlFor="phone" className="block text-sm font-medium text-gray-700 mb-1">
                  {language === 'en' ? 'Phone' : 'شماره تماس'}
                </label>
                <input
                  type="tel"
                  id="phone"
                  name="phone"
                  value={formData.phone}
                  onChange={handleChange}
                  className="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-primary focus:border-primary"
                />
              </div>

              <div>
                <label htmlFor="message" className="block text-sm font-medium text-gray-700 mb-1">
                  {language === 'en' ? 'Message' : 'پیام'}
                </label>
                <textarea
                  id="message"
                  name="message"
                  value={formData.message}
                  onChange={handleChange}
                  required
                  rows={4}
                  className="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-primary focus:border-primary"
                />
              </div>

              <button
                type="submit"
                className="w-full bg-primary text-white py-3 px-4 rounded-md hover:bg-primary-dark transition-colors"
              >
                {language === 'en' ? 'Send Message' : 'ارسال پیام'}
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
} 