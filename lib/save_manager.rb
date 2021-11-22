# frozen_string_literal: true

# Functions to select, save, load, and delete save games.
class SaveManager
  MAXIMUM_SAVE_AGE = 30

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

  def cleanup_old_saves
    saves = saves_list

    saves.each do |save|
      age_in_days = (Date.today - File.mtime(save).to_date).to_i

      delete_game(save) if age_in_days > MAXIMUM_SAVE_AGE
    end
  end

  def delete_game(filename)
    return unless save_exists?(filename)

    File.delete("#{save_folder}/#{filename}")
  end

  def load_game(filename)
    return unless save_exists?(filename)

    reader = File.open("#{@save_folder}/#{filename}")

    saved_game = Marshal.load(reader)

    reader.close

    saved_game
  end

  def saves_list
    save_games = Dir.new(@save_folder)

    save_games.map { |filename| filename unless %w[. ..].include?(filename) }.compact
  end

  def save_exists?(filename)
    save_games = saves_list

    save_games.any?("#{filename}")
  end
end
