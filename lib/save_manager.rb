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

    p saved_game
    puts saved_game.class
    saved_game
    
  end

  # def delete_game
  #   print "\nGames available to delete:\n"
  #   list_saves

  #   filename = ''
  #   filename = filename_prompt until save_exists?(filename) || filename.upcase == 'EXIT'

  #   return if filename.upcase == 'EXIT'

  #   File.delete("#{save_folder}/#{filename}.yaml")

  #   puts "Save \"#{filename}\" is deleted."
  # end

  def saves_list
    save_games = Dir.new(@save_folder)

    save_games.map { |filename| filename.gsub('.yaml', '') unless %w[. ..].include?(filename) }
  end

  def save_exists?(filename)
    save_games = Dir.new(save_folder)

    save_games.any?("#{filename}.yaml")
  end

  private

  # def confirm_overwrite?
  #   answer = ''
  #   until %w[N Y].include?(answer)
  #     print 'A save with this name already exists.  Overwrite? Y / N: '
  #     answer = gets.strip.upcase
  #   end

  #   answer == 'Y'
  # end

  # def filename_prompt
  #   filename = ''

  #   until filename.length.positive?
  #     print 'Enter the name of your save or "exit" to return: '
  #     filename = gets.strip.downcase
  #   end

  #   filename
  # end

  def load_yaml(filename)
    return unless Dir.exist?(@save_folder)

    reader = File.open("#{@save_folder}/#{filename}.yaml")

    safe_load_classes = [
      ChessGame, HumanPlayer, ComputerPlayer,
      GameState
    ]
    YAML.safe_load(reader, safe_load_classes)

  end
end