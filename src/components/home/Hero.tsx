import Image from 'next/image';
import Link from 'next/link';

export default function Hero() {
  return (
    <div className="relative h-[600px]">
      {/* Background Image */}
      <div className="absolute inset-0">
        <Image
          src="/hero-bg.jpg"
          alt="International Homes Hero"
          fill
          className="object-cover"
          priority
        />
        <div className="absolute inset-0 bg-black/40" />
      </div>

      {/* Content */}
      <div className="relative container mx-auto px-4 h-full flex flex-col justify-center">
        <div className="max-w-2xl">
          <h1 className="text-4xl md:text-5xl font-bold text-white mb-6">
            Discover Your Perfect International Getaway
          </h1>
          <p className="text-xl text-white/90 mb-8">
            Find and book unique accommodations in the world's most beautiful destinations
          </p>
          
          {/* Search Box */}
          <div className="bg-white rounded-xl p-4 shadow-lg">
            <div className="flex flex-col md:flex-row gap-4">
              <div className="flex-1">
                <input
                  type="text"
                  placeholder="Search for destinations..."
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                />
              </div>
              <div className="flex-1">
                <input
                  type="text"
                  placeholder="Check-in date"
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                />
              </div>
              <div className="flex-1">
                <input
                  type="text"
                  placeholder="Check-out date"
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                />
              </div>
              <button className="btn-primary whitespace-nowrap">
                Search
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
} 