'use client';

import { useState } from 'react';
import Image from 'next/image';
import { IoClose } from 'react-icons/io5';
import { FiChevronLeft, FiChevronRight } from 'react-icons/fi';
import { Icon } from './Icons';

interface ImageGalleryProps {
  images: string[];
  mainImage: string;
  title: string;
}

export default function ImageGallery({ images, mainImage, title }: ImageGalleryProps) {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const allImages = [mainImage, ...images.filter(img => img !== mainImage)];

  const handlePrevious = () => {
    setCurrentImageIndex((prev) => 
      prev === 0 ? allImages.length - 1 : prev - 1
    );
  };

  const handleNext = () => {
    setCurrentImageIndex((prev) => 
      prev === allImages.length - 1 ? 0 : prev + 1
    );
  };

  const handleKeyDown = (e: KeyboardEvent) => {
    if (e.key === 'ArrowLeft') handlePrevious();
    if (e.key === 'ArrowRight') handleNext();
    if (e.key === 'Escape') setIsModalOpen(false);
  };

  return (
    <>
      {/* Main Image */}
      <div className="relative h-[500px] rounded-t-2xl overflow-hidden">
        <Image
          src={mainImage}
          alt={title}
          fill
          className="object-cover cursor-pointer hover:opacity-95 transition-opacity"
          onClick={() => {
            setCurrentImageIndex(0);
            setIsModalOpen(true);
          }}
        />
        <div className="absolute inset-0 bg-gradient-to-b from-black/10 to-transparent" />
      </div>

      {/* Thumbnails */}
      {images.length > 1 && (
        <div className="grid grid-cols-4 gap-2 p-2 bg-white rounded-b-2xl">
          {allImages.slice(0, 4).map((image, index) => (
            <div 
              key={index} 
              className="relative h-24 rounded-lg overflow-hidden cursor-pointer"
              onClick={() => {
                setCurrentImageIndex(index);
                setIsModalOpen(true);
              }}
            >
              <Image
                src={image}
                alt={`${title} - ${index + 1}`}
                fill
                className="object-cover hover:opacity-80 transition-opacity"
              />
              {index === 3 && allImages.length > 4 && (
                <div className="absolute inset-0 flex items-center justify-center bg-black/50 text-white font-medium">
                  +{allImages.length - 4}
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {/* Modal/Lightbox */}
      {isModalOpen && (
        <div 
          className="fixed inset-0 z-50 bg-black/90 flex items-center justify-center"
          onClick={() => setIsModalOpen(false)}
        >
          <div className="relative w-full h-full flex items-center justify-center p-4">
            {/* Close button */}
            <button
              className="absolute top-4 right-4 text-white p-2 rounded-full bg-black/50 hover:bg-black/70 transition-colors"
              onClick={() => setIsModalOpen(false)}
            >
              <IoClose size={24} />
            </button>

            {/* Navigation buttons */}
            <button
              className="absolute left-4 text-white p-2 rounded-full bg-black/50 hover:bg-black/70 transition-colors"
              onClick={(e) => {
                e.stopPropagation();
                handlePrevious();
              }}
            >
              <FiChevronLeft size={24} />
            </button>
            <button
              className="absolute right-4 text-white p-2 rounded-full bg-black/50 hover:bg-black/70 transition-colors"
              onClick={(e) => {
                e.stopPropagation();
                handleNext();
              }}
            >
              <FiChevronRight size={24} />
            </button>

            {/* Current image */}
            <div className="relative w-full h-full max-w-5xl max-h-[80vh]">
              <Image
                src={allImages[currentImageIndex]}
                alt={`${title} - ${currentImageIndex + 1}`}
                fill
                className="object-contain"
                onClick={(e) => e.stopPropagation()}
              />
            </div>

            {/* Image counter */}
            <div className="absolute bottom-4 left-1/2 -translate-x-1/2 text-white bg-black/50 px-3 py-1 rounded-full">
              {currentImageIndex + 1} / {allImages.length}
            </div>
          </div>
        </div>
      )}
    </>
  );
} 