'use client';

import { IconType } from 'react-icons';
import { FaBed, FaBath, FaRulerCombined, FaWhatsapp, FaRegCalendarAlt } from 'react-icons/fa';
import { IoLocationSharp, IoClose, IoMenu } from 'react-icons/io5';
import { BsHouseDoor } from 'react-icons/bs';
import { FiChevronLeft, FiChevronRight } from 'react-icons/fi';

interface IconProps {
  icon: IconType;
  size?: number;
  className?: string;
}

export function Icon({ icon: IconComponent, size = 24, className = '' }: IconProps) {
  return <IconComponent size={size} className={className} />;
}

export const Icons = {
  Bed: FaBed,
  Bath: FaBath,
  Area: FaRulerCombined,
  WhatsApp: FaWhatsapp,
  Calendar: FaRegCalendarAlt,
  Location: IoLocationSharp,
  House: BsHouseDoor,
  Close: IoClose,
  ChevronLeft: FiChevronLeft,
  ChevronRight: FiChevronRight,
  Menu: IoMenu,
} as const; 