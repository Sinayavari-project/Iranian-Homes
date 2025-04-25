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