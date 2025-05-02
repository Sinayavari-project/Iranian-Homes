export type Language = 'en' | 'fa';

export const translations = {
  en: {
    hero: {
      title: "Discover Your Perfect International Getaway",
      description: "Find and book unique accommodations in the world's most beautiful destinations",
      searchPlaceholder: "Search for destinations...",
      checkIn: "Check-in date",
      checkOut: "Check-out date",
      search: "Search"
    },
    popularDestinations: {
      title: "Popular Destinations",
      properties: "properties"
    },
    featuredProperties: {
      title: "Featured Properties",
      perNight: "per night"
    },
    properties: {
      title: "Our Properties",
      bedrooms: "Bedrooms",
      bathrooms: "Bathrooms",
      guests: "Guests",
      amenities: "Amenities",
      reserve: "Reserve",
      perNight: "per night"
    },
    destinations: [
      { id: 1, name: "Paris, France" },
      { id: 2, name: "Bali, Indonesia" },
      { id: 3, name: "Tokyo, Japan" },
      { id: 4, name: "New York, USA" },
      { id: 5, name: "Rome, Italy" },
      { id: 6, name: "Dubai, UAE" }
    ]
  },
  fa: {
    hero: {
      title: "مقصد بین‌المللی رویایی خود را کشف کنید",
      description: "اقامتگاه‌های منحصر به فرد را در زیباترین مقاصد جهان پیدا و رزرو کنید",
      searchPlaceholder: "جستجوی مقصد...",
      checkIn: "تاریخ ورود",
      checkOut: "تاریخ خروج",
      search: "جستجو"
    },
    popularDestinations: {
      title: "مقاصد محبوب",
      properties: "اقامتگاه"
    },
    featuredProperties: {
      title: "اقامتگاه‌های ویژه",
      perNight: "هر شب"
    },
    properties: {
      title: "اقامتگاه‌های ما",
      bedrooms: "اتاق خواب",
      bathrooms: "حمام",
      guests: "مهمان",
      amenities: "امکانات",
      reserve: "رزرو",
      perNight: "هر شب"
    },
    destinations: [
      { id: 1, name: "پاریس، فرانسه" },
      { id: 2, name: "بالی، اندونزی" },
      { id: 3, name: "توکیو، ژاپن" },
      { id: 4, name: "نیویورک، آمریکا" },
      { id: 5, name: "رم، ایتالیا" },
      { id: 6, name: "دبی، امارات" }
    ]
  }
};

export const locationTranslations = {
  en: {
    cities: {
      'Tehran': 'Tehran',
      'Isfahan': 'Isfahan',
      'Kashan': 'Kashan'
    },
    states: {
      'Tehran Province': 'Tehran Province',
      'Isfahan Province': 'Isfahan Province'
    },
    countries: {
      'Iran': 'Iran'
    },
    areas: {
      'Niavaran': 'Niavaran',
      'North Tehran': 'North Tehran',
      'Chaharbagh Boulevard': 'Chaharbagh Boulevard',
      'Historic District': 'Historic District'
    }
  },
  fa: {
    cities: {
      'Tehran': 'تهران',
      'Isfahan': 'اصفهان',
      'Kashan': 'کاشان'
    },
    states: {
      'Tehran Province': 'استان تهران',
      'Isfahan Province': 'استان اصفهان'
    },
    countries: {
      'Iran': 'ایران'
    },
    areas: {
      'Niavaran': 'نیاوران',
      'North Tehran': 'شمال تهران',
      'Chaharbagh Boulevard': 'خیابان چهارباغ',
      'Historic District': 'محله تاریخی'
    }
  }
};

export function translateLocation(text: string, type: 'cities' | 'states' | 'countries' | 'areas', language: string): string {
  const translations = locationTranslations[language as keyof typeof locationTranslations];
  return translations[type][text as keyof typeof translations[typeof type]] || text;
} 