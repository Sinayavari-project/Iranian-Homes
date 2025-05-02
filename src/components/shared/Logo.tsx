import React from 'react';

interface LogoProps {
  className?: string;
  size?: 'sm' | 'md' | 'lg';
  variant?: 'light' | 'dark';
}

const sizeClasses = {
  sm: 'h-8',
  md: 'h-12',
  lg: 'h-16'
};

export function Logo({ className = '', size = 'md', variant = 'light' }: LogoProps) {
  const isDark = variant === 'dark';

  return (
    <div className={`relative ${sizeClasses[size]} aspect-[3/1] ${className}`}>
      {/* Nature-inspired background */}
      <div className="absolute inset-0 rounded-xl overflow-hidden">
        <div 
          className={`absolute inset-0 ${
            isDark 
              ? 'bg-gradient-to-r from-emerald-900 to-sky-900' 
              : 'bg-gradient-to-r from-emerald-500/90 to-sky-500/90'
          }`} 
        />
        <div 
          className={`absolute inset-0 ${
            isDark
              ? 'bg-[radial-gradient(circle_at_50%_120%,rgba(255,255,255,0.1)_0%,rgba(255,255,255,0)_60%)]'
              : 'bg-[radial-gradient(circle_at_50%_120%,rgba(255,255,255,0.2)_0%,rgba(255,255,255,0)_60%)]'
          }`}
        />
      </div>
      
      {/* Logo text */}
      <div className="relative h-full flex items-center px-4">
        <span 
          className={`font-bold tracking-wider ${isDark ? 'text-gray-100' : 'text-white'}`} 
          style={{ fontSize: '40%', lineHeight: '100%' }}
        >
          Rentoro
        </span>
        
        {/* Decorative elements */}
        <div className="absolute right-3 top-1/2 -translate-y-1/2 flex items-center space-x-1">
          <div className={`w-1.5 h-1.5 rounded-full ${isDark ? 'bg-gray-100/80' : 'bg-white/80'}`} />
          <div className={`w-1.5 h-1.5 rounded-full ${isDark ? 'bg-gray-100/60' : 'bg-white/60'}`} />
          <div className={`w-1.5 h-1.5 rounded-full ${isDark ? 'bg-gray-100/40' : 'bg-white/40'}`} />
        </div>
      </div>
    </div>
  );
} 