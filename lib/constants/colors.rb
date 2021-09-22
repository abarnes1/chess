# frozen_string_literal: true

# Color constants for foreground (font) and background colors for
# Ruby terminal applications.
class Colors
  def self.random_foreground
    ((30..37).to_a + (90..97).to_a).sample.to_s
  end

  def self.random_background
    ((40..47).to_a + (100..107).to_a).sample.to_s
  end

  self::BLACK = '30'
  self::RED = '31'
  self::GREEN = '32'
  self::BROWN = '33'
  self::BLUE = '34'
  self::MAGENTA = '35'
  self::CYAN = '36'
  self::GRAY = '37'

  self::BG_BLACK = '40'
  self::BG_RED = '41'
  self::BG_GREEN = '42'
  self::BG_BROWN = '43'
  self::BG_BLUE = '44'
  self::BG_MAGENTA = '45'
  self::BG_CYAN = '46'
  self::BG_GRAY = '47'

  # https://chrisyeh96.github.io/2020/03/28/terminal-colors.html
  # 90-97	bright foreground color (non-standard)
  # 100-107	bright background color (non-standard)

  self::BRIGHT_BLACK = '90'
  self::BRIGHT_RED = '91'
  self::BRIGHT_GREEN = '92'
  self::BRIGHT_BROWN = '93'
  self::BRIGHT_BLUE = '94'
  self::BRIGHT_MAGENTA = '95'
  self::BRIGHT_CYAN = '96'
  self::BRIGHT_GRAY = '97'

  self::BG_BRIGHT_BLACK = '100'
  self::BG_BRIGHT_RED = '101'
  self::BG_BRIGHT_GREEN = '102'
  self::BG_BRIGHT_BROWN = '103'
  self::BG_BRIGHT_BLUE = '104'
  self::BG_BRIGHT_MAGENTA = '105'
  self::BG_BRIGHT_CYAN = '106'
  self::BG_BRIGHT_GRAY = '107'
end
