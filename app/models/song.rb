class Song < ApplicationRecord
    belongs_to :album
    has_many :song_vibes, dependent: :destroy
    has_many :vibes, through: :song_vibes
    validates :name, presence: true

    before_save :apply_vibe_list, if: -> { @vibe_list }

    # Vibes as editable text, e.g. %("late night" "chill" upbeat).
    def vibe_list
        @vibe_list || vibes.map { |vibe| %("#{vibe.name}") }.join(" ")
    end

    # Accepts quoted phrases and/or bare words. Applied only when the song
    # saves successfully, so a failed save never creates or links vibes.
    def vibe_list=(text)
        @vibe_list = text.to_s
    end

    private

    def apply_vibe_list
        names = @vibe_list.scan(/"([^"]*)"|(\S+)/).map { |quoted, bare| (quoted || bare).squish.delete('"') }
        names = names.reject(&:blank?).uniq(&:downcase)

        # Reuse existing vibes case-insensitively; create the rest.
        self.vibes = names.map do |name|
            Vibe.find_by("LOWER(name) = ?", name.downcase) || Vibe.new(name: name)
        end
        @vibe_list = nil
    end
end
