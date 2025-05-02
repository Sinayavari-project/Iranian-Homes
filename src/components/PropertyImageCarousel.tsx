import { useState } from 'react';
import Image from 'next/image';
import { ChevronLeftIcon, ChevronRightIcon } from '@heroicons/react/24/outline';
import { useSwipeable } from 'react-swipeable';

interface PropertyImageCarouselProps {
  images: string[];
  title: string;
}

export default function PropertyImageCarousel({ images, title }: PropertyImageCarouselProps) {
  const [currentImageIndex, setCurrentImageIndex] = useState(0);

  const nextImage = () => {
    setCurrentImageIndex((prev) => (prev + 1) % images.length);
  };

  const previousImage = () => {
    setCurrentImageIndex((prev) => (prev - 1 + images.length) % images.length);
  };

  const handlers = useSwipeable({
    onSwipedLeft: nextImage,
    onSwipedRight: previousImage,
  });

  return (
    <div className="relative w-full h-[300px] group rounded-xl overflow-hidden">
      <div {...handlers} className="relative w-full h-full">
        <Image
          src={images[currentImageIndex]}
          alt={`${title} - Image ${currentImageIndex + 1}`}
          fill
          className="object-cover transition-transform duration-500"
          sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
          priority={currentImageIndex === 0}
        />
      </div>

      {/* Navigation Buttons */}
      <button
        onClick={previousImage}
        className="absolute left-2 top-1/2 -translate-y-1/2 bg-white/80 rounded-full p-1.5 
                 opacity-0 group-hover:opacity-100 transition-opacity duration-300
                 hover:bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary"
        aria-label="Previous image"
      >
        <ChevronLeftIcon className="w-4 h-4 text-gray-800" />
      </button>

      <button
        onClick={nextImage}
        className="absolute right-2 top-1/2 -translate-y-1/2 bg-white/80 rounded-full p-1.5
                 opacity-0 group-hover:opacity-100 transition-opacity duration-300
                 hover:bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary"
        aria-label="Next image"
      >
        <ChevronRightIcon className="w-4 h-4 text-gray-800" />
      </button>

      {/* Image Indicators */}
      <div className="absolute bottom-2 left-1/2 -translate-x-1/2 flex gap-1">
        {images.map((_, index) => (
          <button
            key={index}
            onClick={() => setCurrentImageIndex(index)}
            className={`w-1.5 h-1.5 rounded-full transition-all duration-300
                      ${currentImageIndex === index 
                        ? 'bg-white w-2.5' 
                        : 'bg-white/60 hover:bg-white/80'}`}
            aria-label={`Go to image ${index + 1}`}
          />
        ))}
      </div>
    </div>
  );
} 