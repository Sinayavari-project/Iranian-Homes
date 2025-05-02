const farsiDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

export function toFarsiNumber(n: number): string {
  return n.toString().split('').map(c => {
    return farsiDigits[parseInt(c)] || c;
  }).join('');
}

export function formatPrice(price: number, language: string = 'en'): string {
  // Convert to billions/millions format
  let formatted: string;
  if (price >= 1000000000) {
    formatted = (price / 1000000000).toFixed(1) + (language === 'fa' ? ' میلیارد' : 'B');
  } else if (price >= 1000000) {
    formatted = (price / 1000000).toFixed(1) + (language === 'fa' ? ' میلیون' : 'M');
  } else {
    formatted = price.toLocaleString();
  }

  // Convert digits to Farsi if needed
  if (language === 'fa') {
    return toFarsiNumber(parseFloat(formatted));
  }

  return formatted;
}

export function createWhatsAppUrl(property: { title: string; titleFa: string; price: number }, language: string = 'en'): string {
  const propertyTitle = language === 'fa' ? property.titleFa : property.title;
  const formattedPrice = formatPrice(property.price, language);
  const message = encodeURIComponent(
    language === 'fa' 
      ? `سلام، من علاقه‌مند به رزرو این ملک هستم:\n${propertyTitle}\nقیمت: ${formattedPrice} تومان`
      : `Hello, I'm interested in booking this property:\n${propertyTitle}\nPrice: ${formattedPrice} Toman`
  );
  return `https://wa.me/971506942198?text=${message}`;
} 