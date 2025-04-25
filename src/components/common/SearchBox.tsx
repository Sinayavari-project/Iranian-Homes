import { useState, useRef, useEffect } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import DatePicker from 'react-datepicker';
import "react-datepicker/dist/react-datepicker.css";

export default function SearchBox() {
  const { t, language } = useLanguage();
  const [searchTerm, setSearchTerm] = useState('');
  const [isOpen, setIsOpen] = useState(false);
  const [checkIn, setCheckIn] = useState<Date | null>(null);
  const [checkOut, setCheckOut] = useState<Date | null>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);

  const destinations = t('destinations');

  const filteredDestinations = destinations.filter((dest: { name: string }) =>
    dest.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleDestinationSelect = (destination: string) => {
    setSearchTerm(destination);
    setIsOpen(false);
  };

  return (
    <div className="flex flex-col md:flex-row gap-4 w-full max-w-4xl mx-auto bg-white p-4 rounded-lg shadow-lg">
      <div className="relative flex-1" ref={dropdownRef}>
        <input
          type="text"
          value={searchTerm}
          onChange={(e) => {
            setSearchTerm(e.target.value);
            setIsOpen(true);
          }}
          onFocus={() => setIsOpen(true)}
          placeholder={t('hero.searchPlaceholder')}
          className={`w-full p-3 border rounded-lg ${language === 'fa' ? 'text-right' : 'text-left'}`}
        />
        {isOpen && filteredDestinations.length > 0 && (
          <div className="absolute z-10 w-full mt-1 bg-white border rounded-lg shadow-lg max-h-60 overflow-y-auto">
            {filteredDestinations.map((dest: { id: number; name: string }) => (
              <div
                key={dest.id}
                className="p-3 hover:bg-gray-100 cursor-pointer"
                onClick={() => handleDestinationSelect(dest.name)}
              >
                {dest.name}
              </div>
            ))}
          </div>
        )}
      </div>

      <div className="flex-1">
        <DatePicker
          selected={checkIn}
          onChange={(date) => setCheckIn(date)}
          placeholderText={t('hero.checkIn')}
          className={`w-full p-3 border rounded-lg ${language === 'fa' ? 'text-right' : 'text-left'}`}
          dateFormat={language === 'fa' ? 'yyyy/MM/dd' : 'MM/dd/yyyy'}
        />
      </div>

      <div className="flex-1">
        <DatePicker
          selected={checkOut}
          onChange={(date) => setCheckOut(date)}
          placeholderText={t('hero.checkOut')}
          className={`w-full p-3 border rounded-lg ${language === 'fa' ? 'text-right' : 'text-left'}`}
          dateFormat={language === 'fa' ? 'yyyy/MM/dd' : 'MM/dd/yyyy'}
          minDate={checkIn || new Date()}
        />
      </div>

      <button className="bg-primary text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition-colors">
        {t('hero.search')}
      </button>
    </div>
  );
} 