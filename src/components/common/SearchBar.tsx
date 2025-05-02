'use client';

import { useState } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import { MagnifyingGlassIcon } from '@heroicons/react/24/solid';

interface SearchBarProps {
  onSearch: (query: string) => void;
}

export default function SearchBar({ onSearch }: SearchBarProps) {
  const { t, language } = useLanguage();
  const [isExpanded, setIsExpanded] = useState(false);
  const [searchValue, setSearchValue] = useState('');

  const handleSearch = () => {
    onSearch(searchValue);
  };

  const handleKeyPress = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      handleSearch();
    }
  };

  return (
    <div className="w-full max-w-[850px] mx-auto">
      <div 
        className="flex items-center border border-gray-200 rounded-full hover:shadow-lg transition-shadow duration-200 divide-x"
        onClick={() => setIsExpanded(true)}
      >
        <div className="flex-1 px-6 py-3 cursor-pointer">
          <div className="text-sm font-medium">Where</div>
          <input 
            type="text"
            value={searchValue}
            onChange={(e) => setSearchValue(e.target.value)}
            onKeyPress={handleKeyPress}
            placeholder="Search destinations"
            className="text-sm text-gray-500 w-full outline-none"
          />
        </div>

        <div className="px-6 py-3 cursor-pointer">
          <div className="text-sm font-medium">Check in</div>
          <div className="text-sm text-gray-500">Add dates</div>
        </div>

        <div className="px-6 py-3 cursor-pointer">
          <div className="text-sm font-medium">Check out</div>
          <div className="text-sm text-gray-500">Add dates</div>
        </div>

        <div className="flex items-center px-6 py-3 cursor-pointer">
          <div className="flex-1">
            <div className="text-sm font-medium">Who</div>
            <div className="text-sm text-gray-500">Add guests</div>
          </div>
          <button 
            className="bg-primary text-white p-3 rounded-full hover:bg-primary-dark"
            onClick={handleSearch}
          >
            <MagnifyingGlassIcon className="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
  );
} 