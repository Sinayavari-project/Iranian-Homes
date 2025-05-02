'use client';

import { useState, useRef } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import { ChevronLeftIcon, ChevronRightIcon } from '@heroicons/react/24/solid';
import { 
  TicketIcon,
  HomeIcon,
  BuildingOffice2Icon,
  BeakerIcon,
  HomeModernIcon,
  BuildingLibraryIcon,
  CloudIcon,
  GlobeAsiaAustraliaIcon,
} from '@heroicons/react/24/outline';

interface FilterBarProps {
  onFilterChange: (filters: {
    propertyType: string;
    minPrice: string;
    maxPrice: string;
    minBedrooms: string;
    maxBedrooms: string;
    amenities: string[];
    instantBook: boolean;
    superhost: boolean;
  }) => void;
}

const filters = [
  { id: 'all', label: 'All', icon: TicketIcon },
  { id: 'apartment', label: 'Apartments', icon: HomeIcon },
  { id: 'villa', label: 'Villas', icon: BuildingOffice2Icon },
  { id: 'penthouse', label: 'Penthouses', icon: BeakerIcon },
  { id: 'room', label: 'Rooms', icon: HomeModernIcon },
  { id: 'instant', label: 'Instant Book', icon: BuildingLibraryIcon },
  { id: 'superhost', label: 'Superhost', icon: CloudIcon },
  { id: 'luxury', label: 'Luxury', icon: GlobeAsiaAustraliaIcon },
];

export default function FilterBar({ onFilterChange }: FilterBarProps) {
  const { t, language } = useLanguage();
  const [selectedFilter, setSelectedFilter] = useState('all');
  const scrollContainerRef = useRef<HTMLDivElement>(null);
  const [showLeftScroll, setShowLeftScroll] = useState(false);
  const [showRightScroll, setShowRightScroll] = useState(true);

  const scroll = (direction: 'left' | 'right') => {
    if (scrollContainerRef.current) {
      const scrollAmount = 200;
      const newScrollLeft = direction === 'left' 
        ? scrollContainerRef.current.scrollLeft - scrollAmount
        : scrollContainerRef.current.scrollLeft + scrollAmount;
      
      scrollContainerRef.current.scrollTo({
        left: newScrollLeft,
        behavior: 'smooth'
      });
    }
  };

  const handleScroll = () => {
    if (scrollContainerRef.current) {
      const { scrollLeft, scrollWidth, clientWidth } = scrollContainerRef.current;
      setShowLeftScroll(scrollLeft > 0);
      setShowRightScroll(scrollLeft < scrollWidth - clientWidth - 10);
    }
  };

  const handleFilterClick = (filterId: string) => {
    setSelectedFilter(filterId);
    
    // Update filters based on selection
    const newFilters = {
      propertyType: '',
      minPrice: '',
      maxPrice: '',
      minBedrooms: '',
      maxBedrooms: '',
      amenities: [] as string[],
      instantBook: false,
      superhost: false
    };

    switch (filterId) {
      case 'apartment':
      case 'villa':
      case 'penthouse':
      case 'room':
        newFilters.propertyType = filterId;
        break;
      case 'instant':
        newFilters.instantBook = true;
        break;
      case 'superhost':
        newFilters.superhost = true;
        break;
      case 'luxury':
        newFilters.minPrice = '2000';
        break;
      // 'all' case resets filters to default
    }

    onFilterChange(newFilters);
  };

  return (
    <div className="relative w-full">
      {showLeftScroll && (
        <button 
          onClick={() => scroll('left')}
          className="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-white rounded-full p-2 shadow-md hover:scale-110 transition-transform"
        >
          <ChevronLeftIcon className="w-4 h-4" />
        </button>
      )}
      
      <div 
        ref={scrollContainerRef}
        className="flex space-x-8 overflow-x-auto scrollbar-hide py-4 px-8"
        onScroll={handleScroll}
      >
        {filters.map((filter) => {
          const Icon = filter.icon;
          return (
            <button
              key={filter.id}
              onClick={() => handleFilterClick(filter.id)}
              className={`flex flex-col items-center min-w-[80px] group ${
                selectedFilter === filter.id 
                  ? 'border-b-2 border-black pb-2' 
                  : 'opacity-70 hover:opacity-100 pb-4'
              }`}
            >
              <Icon className="w-6 h-6" />
              <span className="text-xs mt-2">{filter.label}</span>
            </button>
          );
        })}
      </div>

      {showRightScroll && (
        <button 
          onClick={() => scroll('right')}
          className="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-white rounded-full p-2 shadow-md hover:scale-110 transition-transform"
        >
          <ChevronRightIcon className="w-4 h-4" />
        </button>
      )}

      <div className="absolute right-8 top-1/2 -translate-y-1/2">
        <button 
          onClick={() => {
            // TODO: Implement advanced filters modal
          }}
          className="flex items-center gap-2 px-4 py-3 border rounded-lg hover:shadow-md transition-shadow"
        >
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-4 h-4">
            <path strokeLinecap="round" strokeLinejoin="round" d="M10.5 6h9.75M10.5 6a1.5 1.5 0 1 1-3 0m3 0a1.5 1.5 0 1 0-3 0M3.75 6H7.5m3 12h9.75m-9.75 0a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m-3.75 0H7.5m9-6h3.75m-3.75 0a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m-9.75 0h9.75" />
          </svg>
          Filters
        </button>
      </div>
    </div>
  );
} 