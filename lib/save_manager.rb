# frozen_string_literal: true

require 'yaml'

# Functions to select, save, load, and delete save games.
class SaveManager
  def initialize(save_folder)
    @save_folder = save_folder
  end

  def save_folder
    Dir.mkdir(@save_folder) unless Dir.exist?(@save_folder)

    @save_folder
  end

  def save_game(game, filename)
    writer = File.new("#{save_folder}/#{filename}", 'w')

    writer.puts(Marshal.dump(game))
    writer.close
  end

  def load_game(filename)
    puts "loading #{filename}"
    return unless Dir.exist?(@save_folder)

    reader = File.open("#{@save_folder}/#{filename}")

    saved_game = Marshal.load(reader)

    reader.close

    saved_game
  end

  def saves_list
    save_games = Dir.new(@save_folder)

    save_games.map { |filename| filename.gsub('.yaml', '') unless %w[. ..].include?(filename) }
  end

  def save_exists?(filename)
    save_games = Dir.new(save_folder)

    save_games.any?("#{filename}.yaml")
  end
end
