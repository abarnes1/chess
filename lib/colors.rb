class Colors
  self::BLACK = '30'.freeze
  self::RED = '31'.freeze
  self::GREEN = '32'.freeze
  self::BROWN = '33'.freeze
  self::BLUE = '34'.freeze
  self::MAGENTA = '35'.freeze
  self::CYAN = '36'.freeze
  self::GRAY = '37'.freeze

  self::BG_BLACK = '40'.freeze
  self::BG_RED = '41'.freeze
  self::BG_GREEN = '42'.freeze
  self::BG_BROWN = '43'.freeze
  self::BG_BLUE = '44'.freeze
  self::BG_MAGENTA = '45'.freeze
  self::BG_CYAN = '46'.freeze
  self::BG_GRAY = '47'.freeze

  # https://chrisyeh96.github.io/2020/03/28/terminal-colors.html
  # 90-97	bright foreground color (non-standard)
  # 100-107	bright background color (non-standard)

  self::BRIGHT_BLACK = '90'.freeze
  self::BRIGHT_RED = '91'.freeze
  self::BRIGHT_GREEN = '92'.freeze
  self::BRIGHT_BROWN = '93'.freeze
  self::BRIGHT_BLUE = '94'.freeze
  self::BRIGHT_MAGENTA = '95'.freeze
  self::BRIGHT_CYAN = '96'.freeze
  self::BRIGHT_GRAY = '97'.freeze

  self::BG_BRIGHT_BLACK = '100'.freeze
  self::BG_BRIGHT_RED = '101'.freeze
  self::BG_BRIGHT_GREEN = '102'.freeze
  self::BG_BRIGHT_BROWN = '103'.freeze
  self::BG_BRIGHT_BLUE = '104'.freeze
  self::BG_BRIGHT_MAGENTA = '105'.freeze
  self::BG_BRIGHT_CYAN = '106'.freeze
  self::BG_BRIGHT_GRAY = '107'.freeze
end