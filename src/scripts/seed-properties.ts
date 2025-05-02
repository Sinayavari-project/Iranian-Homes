import connectDB from '../lib/mongodb';
import Property from '../models/Property';

const properties = [
  {
    title: 'Traditional House in Kashan',
    summary: 'Experience authentic Persian living in a beautifully restored traditional house',
    description: `This stunning traditional house in the historic city of Kashan offers a unique blend of Persian architecture and modern comfort. The house features a central courtyard with a small pool, traditional stained glass windows, and intricate mirror work. Recently renovated with modern amenities while preserving its historic charm.`,
    mainImage: '/images/properties/kashan1-main.jpg',
    images: [
      '/images/properties/kashan1-1.jpg',
      '/images/properties/kashan1-2.jpg',
      '/images/properties/kashan1-3.jpg',
      '/images/properties/kashan1-4.jpg'
    ],
    location: {
      city: 'Kashan',
      neighborhood: 'Historic District',
      area: 'Near Fin Garden',
      coordinates: {
        latitude: 33.9850,
        longitude: 51.4100
      }
    },
    propertyType: 'traditional',
    bedrooms: 3,
    bathrooms: 2,
    guests: 6,
    amenities: {
      basic: {
        wifi: true,
        airConditioning: true,
        heating: true,
        kitchen: true,
        tv: true,
        parking: true,
        elevator: false
      },
      outdoor: {
        pool: true,
        garden: true,
        balcony: false,
        bbq: false,
        privateYard: true
      },
      safety: {
        securityCameras: true,
        smokeAlarm: true,
        firstAidKit: true,
        fireExtinguisher: true,
        doorman: false
      },
      convenience: {
        washer: true,
        dryer: true,
        ironingEssentials: true,
        workspace: true,
        essentials: true
      }
    },
    rules: {
      smoking: false,
      pets: false,
      parties: false,
      minimumStay: 2,
      quietHours: {
        start: '22:00',
        end: '08:00'
      }
    },
    contact: {
      whatsapp: '+989123456789',
      phone: '+982155667788',
      telegram: '@kashanhouse'
    },
    features: {
      isFeatured: true,
      instantBook: true,
      superhost: true
    },
    pricing: {
      basePrice: 5500000, // 5.5 million Rials per night
      weekendPrice: 6500000,
      weeklyDiscount: 10,
      monthlyDiscount: 20,
      cleaningFee: 1000000,
      deposit: 10000000
    },
    availability: {
      checkInTime: '14:00',
      checkOutTime: '12:00',
      minStay: 2,
      maxStay: 30
    },
    stats: {
      rating: 4.9,
      reviewCount: 45,
      viewCount: 1200,
      bookingCount: 89
    },
    languages: ['Persian', 'English'],
    cancellationPolicy: 'moderate'
  },
  {
    title: 'Luxury Villa with Caspian Sea View',
    summary: 'Modern beachfront villa with private access to the Caspian Sea',
    description: `Experience luxury living in this stunning beachfront villa in Mahmoudabad. Floor-to-ceiling windows offer breathtaking views of the Caspian Sea. The villa features a private garden leading directly to the beach, a fully equipped modern kitchen, and spacious living areas perfect for family gatherings.`,
    mainImage: '/images/properties/caspian1-main.jpg',
    images: [
      '/images/properties/caspian1-1.jpg',
      '/images/properties/caspian1-2.jpg',
      '/images/properties/caspian1-3.jpg',
      '/images/properties/caspian1-4.jpg'
    ],
    location: {
      city: 'Mahmoudabad',
      neighborhood: 'Beachfront',
      area: 'North Coastal Road',
      coordinates: {
        latitude: 36.6279,
        longitude: 52.2656
      }
    },
    propertyType: 'villa',
    bedrooms: 4,
    bathrooms: 3,
    guests: 8,
    amenities: {
      basic: {
        wifi: true,
        airConditioning: true,
        heating: true,
        kitchen: true,
        tv: true,
        parking: true,
        elevator: false
      },
      outdoor: {
        pool: false,
        garden: true,
        balcony: true,
        bbq: true,
        privateYard: true
      },
      safety: {
        securityCameras: true,
        smokeAlarm: true,
        firstAidKit: true,
        fireExtinguisher: true,
        doorman: false
      },
      convenience: {
        washer: true,
        dryer: true,
        ironingEssentials: true,
        workspace: true,
        essentials: true
      }
    },
    rules: {
      smoking: false,
      pets: true,
      parties: false,
      minimumStay: 2,
      quietHours: {
        start: '23:00',
        end: '08:00'
      }
    },
    contact: {
      whatsapp: '+989123456790',
      phone: '+981144556677',
      telegram: '@caspianluxury'
    },
    features: {
      isFeatured: true,
      instantBook: true,
      superhost: true
    },
    pricing: {
      basePrice: 12000000, // 12 million Rials per night
      weekendPrice: 15000000,
      weeklyDiscount: 15,
      monthlyDiscount: 25,
      cleaningFee: 2000000,
      deposit: 20000000
    },
    availability: {
      checkInTime: '15:00',
      checkOutTime: '11:00',
      minStay: 2,
      maxStay: 14
    },
    stats: {
      rating: 4.8,
      reviewCount: 32,
      viewCount: 890,
      bookingCount: 67
    },
    languages: ['Persian', 'English'],
    cancellationPolicy: 'strict'
  },
  {
    title: 'Modern Apartment in Tehran',
    summary: 'Stylish apartment in the heart of Tehran with city views',
    description: `Located in the prestigious Zaferanieh neighborhood, this modern apartment offers stunning views of Tehran and the Alborz mountains. The apartment features contemporary design, high-end appliances, and 24/7 security. Perfect for business travelers or small families.`,
    mainImage: '/images/properties/tehran1-main.jpg',
    images: [
      '/images/properties/tehran1-1.jpg',
      '/images/properties/tehran1-2.jpg',
      '/images/properties/tehran1-3.jpg'
    ],
    location: {
      city: 'Tehran',
      neighborhood: 'Zaferanieh',
      area: 'North Tehran',
      coordinates: {
        latitude: 35.8000,
        longitude: 51.4333
      }
    },
    propertyType: 'apartment',
    bedrooms: 2,
    bathrooms: 2,
    guests: 4,
    amenities: {
      basic: {
        wifi: true,
        airConditioning: true,
        heating: true,
        kitchen: true,
        tv: true,
        parking: true,
        elevator: true
      },
      outdoor: {
        pool: false,
        garden: false,
        balcony: true,
        bbq: false,
        privateYard: false
      },
      safety: {
        securityCameras: true,
        smokeAlarm: true,
        firstAidKit: true,
        fireExtinguisher: true,
        doorman: true
      },
      convenience: {
        washer: true,
        dryer: true,
        ironingEssentials: true,
        workspace: true,
        essentials: true
      }
    },
    rules: {
      smoking: false,
      pets: false,
      parties: false,
      minimumStay: 3,
      quietHours: {
        start: '22:00',
        end: '07:00'
      }
    },
    contact: {
      whatsapp: '+989123456791',
      phone: '+982122334455',
      telegram: '@tehranmodern'
    },
    features: {
      isFeatured: true,
      instantBook: true,
      superhost: true
    },
    pricing: {
      basePrice: 8000000,
      weekendPrice: 9000000,
      weeklyDiscount: 10,
      monthlyDiscount: 20,
      cleaningFee: 1500000,
      deposit: 15000000
    },
    availability: {
      checkInTime: '14:00',
      checkOutTime: '12:00',
      minStay: 3,
      maxStay: 90
    },
    stats: {
      rating: 4.7,
      reviewCount: 28,
      viewCount: 750,
      bookingCount: 45
    },
    languages: ['Persian', 'English'],
    cancellationPolicy: 'moderate'
  },
  {
    title: 'Charming Villa in Shiraz Garden',
    summary: 'Traditional villa surrounded by gardens in the city of poetry and flowers',
    description: `Experience the magic of Shiraz in this beautiful villa located in the Ghasr-e-Dasht area. The property is surrounded by a lush garden with fruit trees and traditional Persian design elements. Perfect for families looking to explore the historic city of Shiraz.`,
    mainImage: '/images/properties/shiraz1-main.jpg',
    images: [
      '/images/properties/shiraz1-1.jpg',
      '/images/properties/shiraz1-2.jpg',
      '/images/properties/shiraz1-3.jpg',
      '/images/properties/shiraz1-4.jpg'
    ],
    location: {
      city: 'Shiraz',
      neighborhood: 'Ghasr-e-Dasht',
      area: 'Garden District',
      coordinates: {
        latitude: 29.6100,
        longitude: 52.5425
      }
    },
    propertyType: 'villa',
    bedrooms: 3,
    bathrooms: 2.5,
    guests: 6,
    amenities: {
      basic: {
        wifi: true,
        airConditioning: true,
        heating: true,
        kitchen: true,
        tv: true,
        parking: true,
        elevator: false
      },
      outdoor: {
        pool: true,
        garden: true,
        balcony: true,
        bbq: true,
        privateYard: true
      },
      safety: {
        securityCameras: true,
        smokeAlarm: true,
        firstAidKit: true,
        fireExtinguisher: true,
        doorman: false
      },
      convenience: {
        washer: true,
        dryer: true,
        ironingEssentials: true,
        workspace: true,
        essentials: true
      }
    },
    rules: {
      smoking: false,
      pets: true,
      parties: false,
      minimumStay: 2,
      quietHours: {
        start: '22:00',
        end: '08:00'
      }
    },
    contact: {
      whatsapp: '+989123456792',
      phone: '+987136667777',
      telegram: '@shirazgarden'
    },
    features: {
      isFeatured: true,
      instantBook: false,
      superhost: true
    },
    pricing: {
      basePrice: 7000000,
      weekendPrice: 8500000,
      weeklyDiscount: 15,
      monthlyDiscount: 25,
      cleaningFee: 1200000,
      deposit: 14000000
    },
    availability: {
      checkInTime: '15:00',
      checkOutTime: '11:00',
      minStay: 2,
      maxStay: 30
    },
    stats: {
      rating: 4.9,
      reviewCount: 37,
      viewCount: 980,
      bookingCount: 72
    },
    languages: ['Persian', 'English'],
    cancellationPolicy: 'moderate'
  },
  {
    title: 'Cozy Cottage in Masouleh',
    summary: 'Traditional cottage in the historic stepped village of Masouleh',
    description: `Stay in a piece of history in this beautifully preserved cottage in Masouleh. Experience the unique architecture where the roof of one house serves as the yard of the house above. The cottage offers stunning views of the surrounding mountains and the village.`,
    mainImage: '/images/properties/masouleh1-main.jpg',
    images: [
      '/images/properties/masouleh1-1.jpg',
      '/images/properties/masouleh1-2.jpg',
      '/images/properties/masouleh1-3.jpg'
    ],
    location: {
      city: 'Masouleh',
      neighborhood: 'Historic Center',
      area: 'Mountain Village',
      coordinates: {
        latitude: 37.1560,
        longitude: 48.9900
      }
    },
    propertyType: 'cottage',
    bedrooms: 2,
    bathrooms: 1,
    guests: 4,
    amenities: {
      basic: {
        wifi: true,
        airConditioning: false,
        heating: true,
        kitchen: true,
        tv: true,
        parking: false,
        elevator: false
      },
      outdoor: {
        pool: false,
        garden: false,
        balcony: true,
        bbq: false,
        privateYard: false
      },
      safety: {
        securityCameras: false,
        smokeAlarm: true,
        firstAidKit: true,
        fireExtinguisher: true,
        doorman: false
      },
      convenience: {
        washer: false,
        dryer: false,
        ironingEssentials: true,
        workspace: false,
        essentials: true
      }
    },
    rules: {
      smoking: false,
      pets: false,
      parties: false,
      minimumStay: 1,
      quietHours: {
        start: '22:00',
        end: '07:00'
      }
    },
    contact: {
      whatsapp: '+989123456793',
      telegram: '@masoulehstay'
    },
    features: {
      isFeatured: false,
      instantBook: true,
      superhost: false
    },
    pricing: {
      basePrice: 3500000,
      weekendPrice: 4000000,
      weeklyDiscount: 10,
      monthlyDiscount: 20,
      cleaningFee: 800000,
      deposit: 7000000
    },
    availability: {
      checkInTime: '14:00',
      checkOutTime: '11:00',
      minStay: 1,
      maxStay: 14
    },
    stats: {
      rating: 4.6,
      reviewCount: 15,
      viewCount: 450,
      bookingCount: 28
    },
    languages: ['Persian'],
    cancellationPolicy: 'flexible'
  },
  {
    title: 'Luxury Penthouse in Kish',
    summary: 'High-end penthouse with panoramic ocean views in Kish Island',
    description: `Experience luxury island living in this stunning penthouse overlooking the Persian Gulf. The property features modern design, high-end finishes, and a private rooftop terrace. Perfect for those seeking a premium vacation experience in Kish Island.`,
    mainImage: '/images/properties/kish1-main.jpg',
    images: [
      '/images/properties/kish1-1.jpg',
      '/images/properties/kish1-2.jpg',
      '/images/properties/kish1-3.jpg',
      '/images/properties/kish1-4.jpg'
    ],
    location: {
      city: 'Kish',
      neighborhood: 'Sanayi',
      area: 'Waterfront',
      coordinates: {
        latitude: 26.5321,
        longitude: 53.9800
      }
    },
    propertyType: 'apartment',
    bedrooms: 3,
    bathrooms: 3.5,
    guests: 6,
    amenities: {
      basic: {
        wifi: true,
        airConditioning: true,
        heating: true,
        kitchen: true,
        tv: true,
        parking: true,
        elevator: true
      },
      outdoor: {
        pool: true,
        garden: false,
        balcony: true,
        bbq: true,
        privateYard: false
      },
      safety: {
        securityCameras: true,
        smokeAlarm: true,
        firstAidKit: true,
        fireExtinguisher: true,
        doorman: true
      },
      convenience: {
        washer: true,
        dryer: true,
        ironingEssentials: true,
        workspace: true,
        essentials: true
      }
    },
    rules: {
      smoking: false,
      pets: false,
      parties: true,
      minimumStay: 2,
      quietHours: {
        start: '23:00',
        end: '08:00'
      }
    },
    contact: {
      whatsapp: '+989123456794',
      phone: '+987644445555',
      telegram: '@kishluxury'
    },
    features: {
      isFeatured: true,
      instantBook: true,
      superhost: true
    },
    pricing: {
      basePrice: 15000000,
      weekendPrice: 18000000,
      weeklyDiscount: 15,
      monthlyDiscount: 30,
      cleaningFee: 2500000,
      deposit: 30000000
    },
    availability: {
      checkInTime: '15:00',
      checkOutTime: '11:00',
      minStay: 2,
      maxStay: 60
    },
    stats: {
      rating: 4.9,
      reviewCount: 42,
      viewCount: 1500,
      bookingCount: 95
    },
    languages: ['Persian', 'English', 'Arabic'],
    cancellationPolicy: 'strict'
  },
  {
    title: 'Historic House in Isfahan',
    summary: 'Authentic Persian house near Naqsh-e Jahan Square',
    description: `Stay in a piece of history in this beautifully preserved traditional house in Isfahan. Located just minutes from the famous Naqsh-e Jahan Square, this property features authentic Persian architecture, hand-painted miniatures, and a peaceful courtyard with a fountain.`,
    mainImage: '/images/properties/isfahan1-main.jpg',
    images: [
      '/images/properties/isfahan1-1.jpg',
      '/images/properties/isfahan1-2.jpg',
      '/images/properties/isfahan1-3.jpg'
    ],
    location: {
      city: 'Isfahan',
      neighborhood: 'Naqsh-e Jahan',
      area: 'Historic Center',
      coordinates: {
        latitude: 32.6577,
        longitude: 51.6692
      }
    },
    propertyType: 'traditional',
    bedrooms: 2,
    bathrooms: 2,
    guests: 5,
    amenities: {
      basic: {
        wifi: true,
        airConditioning: true,
        heating: true,
        kitchen: true,
        tv: true,
        parking: false,
        elevator: false
      },
      outdoor: {
        pool: false,
        garden: true,
        balcony: false,
        bbq: false,
        privateYard: true
      },
      safety: {
        securityCameras: true,
        smokeAlarm: true,
        firstAidKit: true,
        fireExtinguisher: true,
        doorman: false
      },
      convenience: {
        washer: true,
        dryer: false,
        ironingEssentials: true,
        workspace: true,
        essentials: true
      }
    },
    rules: {
      smoking: false,
      pets: false,
      parties: false,
      minimumStay: 2,
      quietHours: {
        start: '22:00',
        end: '08:00'
      }
    },
    contact: {
      whatsapp: '+989123456795',
      phone: '+983132221111',
      telegram: '@isfahanheritage'
    },
    features: {
      isFeatured: true,
      instantBook: false,
      superhost: true
    },
    pricing: {
      basePrice: 6000000,
      weekendPrice: 7000000,
      weeklyDiscount: 10,
      monthlyDiscount: 20,
      cleaningFee: 1000000,
      deposit: 12000000
    },
    availability: {
      checkInTime: '14:00',
      checkOutTime: '11:00',
      minStay: 2,
      maxStay: 30
    },
    stats: {
      rating: 4.8,
      reviewCount: 56,
      viewCount: 1200,
      bookingCount: 84
    },
    languages: ['Persian', 'English'],
    cancellationPolicy: 'moderate'
  },
  // ... Add 13 more properties here
];

async function seedProperties() {
  try {
    await connectDB();
    
    // Clear existing properties
    await Property.deleteMany({});
    
    // Insert new properties
    await Property.insertMany(properties);
    
    console.log('Successfully seeded properties');
    process.exit(0);
  } catch (error) {
    console.error('Error seeding properties:', error);
    process.exit(1);
  }
}

seedProperties(); 