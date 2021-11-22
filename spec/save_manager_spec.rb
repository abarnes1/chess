require_relative '../lib/save_manager'

describe SaveManager do
  describe '#save_folder' do
    let(:save_folder) { 'saves' } 
    subject(:save_manager) { described_class.new(save_folder) }

    it 'returns the save folder' do
      allow(Dir).to receive(:mkdir)
      actual = save_manager.save_folder

      expect(actual).to eq(save_folder)
    end
  end

  describe '#save_game' do
    let(:save_folder) { 'saves' } 
    let(:save_filename) { 'filename' } 
    subject(:save_manager) { described_class.new(save_folder) }
    let(:file_writer) { double('writer') }
    let(:object_to_save) { Object.new }

    before do
      allow(IO).to receive(:new).and_return(file_writer)
      allow(file_writer).to receive(:puts)
      allow(Marshal).to receive(:dump)
      allow(file_writer).to receive(:close)
    end

    it 'opens a file handle' do
      expect(IO).to receive(:new)

      save_manager.save_game(object_to_save, save_filename)
    end
    
    it 'dumps the game object' do
      expect(Marshal).to receive(:dump)

      save_manager.save_game(object_to_save, save_filename)
    end

    it 'closes the file handle' do
      expect(file_writer).to receive(:close)

      save_manager.save_game(object_to_save, save_filename)
    end
  end

  describe '#delete_game' do
    context 'when save file exists' do
      let(:save_folder) { 'saves' } 
      let(:save_filename) { 'filename' } 
      subject(:save_manager) { described_class.new(save_folder) }

      it 'deletes the file' do
        allow(save_manager).to receive(:save_exists?).with(save_filename).and_return(true)
        allow(File).to receive(:delete)

        expect(File).to receive(:delete)

        save_manager.delete_game(save_filename)
      end
    end

    context 'when save file does not exist' do
      let(:save_folder) { 'saves' } 
      let(:save_filename) { 'filename' } 
      subject(:save_manager) { described_class.new(save_folder) }

      it 'does not access the file system' do
        allow(save_manager).to receive(:save_exists?).with(save_filename).and_return(false)
        allow(File).to receive(:delete)

        expect(File).not_to receive(:delete)

        save_manager.delete_game(save_filename)
      end
    end
  end

  describe '#cleanup_old_saves' do
    let(:save_folder) { 'saves' } 
    let(:save_filename) { 'filename' } 
    subject(:save_manager) { described_class.new(save_folder) }
    let(:forty_five_days_ago) { Date.today - 45 }

    it 'removes old saves' do
      allow(save_manager).to receive(:saves_list).and_return(%w[old_save])
      allow(File).to receive(:mtime).and_return(forty_five_days_ago)
      allow(save_manager).to receive(:delete_game)
      
      expect(save_manager).to receive(:delete_game)

      save_manager.cleanup_old_saves
    end

    it 'does not remove new saves' do
      allow(save_manager).to receive(:saves_list).and_return(%w[new_save])
      allow(File).to receive(:mtime).and_return(Date.today)
      allow(save_manager).to receive(:delete_game)
      
      expect(save_manager).not_to receive(:delete_game)

      save_manager.cleanup_old_saves
    end
  end

  describe '#load_game' do
    context 'when save exists' do
      let(:save_folder) { 'doesnt_matter' } 
      let(:save_name) { 'saved game' } 
      let(:file_reader) { double('reader') }
      subject(:save_manager) { described_class.new(save_folder) }

      it 'returns game object' do
        allow(save_manager).to receive(:save_exists?).with(save_name).and_return(true)
        allow(IO).to receive(:open).and_return(file_reader)
        allow(Marshal).to receive(:load).and_return(Object.new)
        allow(file_reader).to receive(:close)

        actual = save_manager.load_game(save_name)

        expect(actual).not_to be_nil
      end
    end

    context 'when does not exist' do
      let(:save_folder) { 'doesnt_matter' } 
      let(:save_name) { 'saved game' } 
      let(:file_reader) { double('reader') }
      subject(:save_manager) { described_class.new(save_folder) }

      it 'returns nil' do
        allow(save_manager).to receive(:save_exists?).with(save_name).and_return(false)

        actual = save_manager.load_game(save_name)

        expect(actual).to be_nil
      end
    end
  end

  describe '#saves_list' do
    context 'when saves exist' do
      let(:save_folder) { 'doesnt_matter' } 
      subject(:save_manager) { described_class.new(save_folder) }

      it 'returns all saves' do
        allow(Dir).to receive(:new).with(save_folder).and_return(%w[a b c .. .])

        expected = %w[a b c]
        actual = save_manager.saves_list
        expect(actual).to eq(expected)
      end
    end

    context 'when no saves exist' do
      let(:save_folder) { 'doesnt_matter' } 
      subject(:save_manager) { described_class.new(save_folder) }

      it 'returns empty array' do
        allow(Dir).to receive(:new).with(save_folder).and_return(%w[.. .])

        expected = []
        actual = save_manager.saves_list

        expect(actual).to eq(expected)
      end
    end
  end

  describe '#save_exists?' do
    context 'when save exists' do
      let(:save_folder) { 'doesnt_matter' }
      subject(:save_manager) { described_class.new(save_folder) }

      it 'returns true' do
        allow(save_manager).to receive(:saves_list).and_return(%w[a b c])

        actual = save_manager.save_exists?('a')

        expect(actual).to be true
      end
    end

    context 'when save does not exist' do
      let(:save_folder) { 'doesnt_matter' }
      subject(:save_manager) { described_class.new(save_folder) }
      
      it 'returns false' do
        allow(save_manager).to receive(:saves_list).and_return(%w[a b c])

        actual = save_manager.save_exists?('d')

        expect(actual).to be false
      end
    end
  end
end