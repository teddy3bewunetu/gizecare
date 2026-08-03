/// Dialing codes for Telegram phone login.
class TelegramCountryDial {
  const TelegramCountryDial({
    required this.name,
    required this.iso2,
    required this.dialCode,
    required this.flag,
  });

  final String name;
  final String iso2;
  final String dialCode;
  final String flag;

  String get label => '$flag  $dialCode';

  String get searchText =>
      '${name.toLowerCase()} ${iso2.toLowerCase()} $dialCode';
}

/// Common countries; Ethiopia first (app default).
const kTelegramCountryDials = <TelegramCountryDial>[
  TelegramCountryDial(name: 'Ethiopia', iso2: 'ET', dialCode: '+251', flag: '🇪🇹'),
  TelegramCountryDial(name: 'United States', iso2: 'US', dialCode: '+1', flag: '🇺🇸'),
  TelegramCountryDial(name: 'Canada', iso2: 'CA', dialCode: '+1', flag: '🇨🇦'),
  TelegramCountryDial(name: 'United Kingdom', iso2: 'GB', dialCode: '+44', flag: '🇬🇧'),
  TelegramCountryDial(name: 'Germany', iso2: 'DE', dialCode: '+49', flag: '🇩🇪'),
  TelegramCountryDial(name: 'France', iso2: 'FR', dialCode: '+33', flag: '🇫🇷'),
  TelegramCountryDial(name: 'Italy', iso2: 'IT', dialCode: '+39', flag: '🇮🇹'),
  TelegramCountryDial(name: 'Spain', iso2: 'ES', dialCode: '+34', flag: '🇪🇸'),
  TelegramCountryDial(name: 'Netherlands', iso2: 'NL', dialCode: '+31', flag: '🇳🇱'),
  TelegramCountryDial(name: 'Belgium', iso2: 'BE', dialCode: '+32', flag: '🇧🇪'),
  TelegramCountryDial(name: 'Switzerland', iso2: 'CH', dialCode: '+41', flag: '🇨🇭'),
  TelegramCountryDial(name: 'Sweden', iso2: 'SE', dialCode: '+46', flag: '🇸🇪'),
  TelegramCountryDial(name: 'Norway', iso2: 'NO', dialCode: '+47', flag: '🇳🇴'),
  TelegramCountryDial(name: 'Denmark', iso2: 'DK', dialCode: '+45', flag: '🇩🇰'),
  TelegramCountryDial(name: 'Finland', iso2: 'FI', dialCode: '+358', flag: '🇫🇮'),
  TelegramCountryDial(name: 'Ireland', iso2: 'IE', dialCode: '+353', flag: '🇮🇪'),
  TelegramCountryDial(name: 'Portugal', iso2: 'PT', dialCode: '+351', flag: '🇵🇹'),
  TelegramCountryDial(name: 'Poland', iso2: 'PL', dialCode: '+48', flag: '🇵🇱'),
  TelegramCountryDial(name: 'Austria', iso2: 'AT', dialCode: '+43', flag: '🇦🇹'),
  TelegramCountryDial(name: 'Czechia', iso2: 'CZ', dialCode: '+420', flag: '🇨🇿'),
  TelegramCountryDial(name: 'Romania', iso2: 'RO', dialCode: '+40', flag: '🇷🇴'),
  TelegramCountryDial(name: 'Greece', iso2: 'GR', dialCode: '+30', flag: '🇬🇷'),
  TelegramCountryDial(name: 'Turkey', iso2: 'TR', dialCode: '+90', flag: '🇹🇷'),
  TelegramCountryDial(name: 'Russia', iso2: 'RU', dialCode: '+7', flag: '🇷🇺'),
  TelegramCountryDial(name: 'Ukraine', iso2: 'UA', dialCode: '+380', flag: '🇺🇦'),
  TelegramCountryDial(name: 'India', iso2: 'IN', dialCode: '+91', flag: '🇮🇳'),
  TelegramCountryDial(name: 'Pakistan', iso2: 'PK', dialCode: '+92', flag: '🇵🇰'),
  TelegramCountryDial(name: 'Bangladesh', iso2: 'BD', dialCode: '+880', flag: '🇧🇩'),
  TelegramCountryDial(name: 'China', iso2: 'CN', dialCode: '+86', flag: '🇨🇳'),
  TelegramCountryDial(name: 'Japan', iso2: 'JP', dialCode: '+81', flag: '🇯🇵'),
  TelegramCountryDial(name: 'South Korea', iso2: 'KR', dialCode: '+82', flag: '🇰🇷'),
  TelegramCountryDial(name: 'Singapore', iso2: 'SG', dialCode: '+65', flag: '🇸🇬'),
  TelegramCountryDial(name: 'Malaysia', iso2: 'MY', dialCode: '+60', flag: '🇲🇾'),
  TelegramCountryDial(name: 'Indonesia', iso2: 'ID', dialCode: '+62', flag: '🇮🇩'),
  TelegramCountryDial(name: 'Philippines', iso2: 'PH', dialCode: '+63', flag: '🇵🇭'),
  TelegramCountryDial(name: 'Thailand', iso2: 'TH', dialCode: '+66', flag: '🇹🇭'),
  TelegramCountryDial(name: 'Vietnam', iso2: 'VN', dialCode: '+84', flag: '🇻🇳'),
  TelegramCountryDial(name: 'Australia', iso2: 'AU', dialCode: '+61', flag: '🇦🇺'),
  TelegramCountryDial(name: 'New Zealand', iso2: 'NZ', dialCode: '+64', flag: '🇳🇿'),
  TelegramCountryDial(name: 'Brazil', iso2: 'BR', dialCode: '+55', flag: '🇧🇷'),
  TelegramCountryDial(name: 'Mexico', iso2: 'MX', dialCode: '+52', flag: '🇲🇽'),
  TelegramCountryDial(name: 'Argentina', iso2: 'AR', dialCode: '+54', flag: '🇦🇷'),
  TelegramCountryDial(name: 'Chile', iso2: 'CL', dialCode: '+56', flag: '🇨🇱'),
  TelegramCountryDial(name: 'Colombia', iso2: 'CO', dialCode: '+57', flag: '🇨🇴'),
  TelegramCountryDial(name: 'South Africa', iso2: 'ZA', dialCode: '+27', flag: '🇿🇦'),
  TelegramCountryDial(name: 'Nigeria', iso2: 'NG', dialCode: '+234', flag: '🇳🇬'),
  TelegramCountryDial(name: 'Kenya', iso2: 'KE', dialCode: '+254', flag: '🇰🇪'),
  TelegramCountryDial(name: 'Uganda', iso2: 'UG', dialCode: '+256', flag: '🇺🇬'),
  TelegramCountryDial(name: 'Tanzania', iso2: 'TZ', dialCode: '+255', flag: '🇹🇿'),
  TelegramCountryDial(name: 'Ghana', iso2: 'GH', dialCode: '+233', flag: '🇬🇭'),
  TelegramCountryDial(name: 'Egypt', iso2: 'EG', dialCode: '+20', flag: '🇪🇬'),
  TelegramCountryDial(name: 'Morocco', iso2: 'MA', dialCode: '+212', flag: '🇲🇦'),
  TelegramCountryDial(name: 'Sudan', iso2: 'SD', dialCode: '+249', flag: '🇸🇩'),
  TelegramCountryDial(name: 'Somalia', iso2: 'SO', dialCode: '+252', flag: '🇸🇴'),
  TelegramCountryDial(name: 'Djibouti', iso2: 'DJ', dialCode: '+253', flag: '🇩🇯'),
  TelegramCountryDial(name: 'Eritrea', iso2: 'ER', dialCode: '+291', flag: '🇪🇷'),
  TelegramCountryDial(name: 'Rwanda', iso2: 'RW', dialCode: '+250', flag: '🇷🇼'),
  TelegramCountryDial(name: 'Saudi Arabia', iso2: 'SA', dialCode: '+966', flag: '🇸🇦'),
  TelegramCountryDial(name: 'United Arab Emirates', iso2: 'AE', dialCode: '+971', flag: '🇦🇪'),
  TelegramCountryDial(name: 'Qatar', iso2: 'QA', dialCode: '+974', flag: '🇶🇦'),
  TelegramCountryDial(name: 'Kuwait', iso2: 'KW', dialCode: '+965', flag: '🇰🇼'),
  TelegramCountryDial(name: 'Israel', iso2: 'IL', dialCode: '+972', flag: '🇮🇱'),
  TelegramCountryDial(name: 'Jordan', iso2: 'JO', dialCode: '+962', flag: '🇯🇴'),
  TelegramCountryDial(name: 'Lebanon', iso2: 'LB', dialCode: '+961', flag: '🇱🇧'),
];

TelegramCountryDial get kDefaultTelegramCountry => kTelegramCountryDials.first;
