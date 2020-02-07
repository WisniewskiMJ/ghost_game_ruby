class Ai_player

  attr_reader :name, :losses

  def initialize
    @name = "#{self.set_name}(bot)"
    @losses = 0
  end

  def compute_move(players_number, fragment, dictionary)

    alpha = ("a".."z").to_a
    possible_moves = Hash.new(0)
    possible_words = []
    possible_fragments = []
    winning_moves = []

    alpha.each do |letter|
      dictionary.each do |word|
        if word.index(fragment + letter) == 0
          possible_words << word
          possible_fragments << fragment + letter if !possible_fragments.include?(fragment + letter)
          if word[fragment.length..-1].length % players_number == 0 && word[fragment.length..-1].length > 0
            possible_moves[letter] += 1
          elsif word[fragment.length..-1].length % players_number != 0
            possible_moves[letter] -= 1
          end
        end
      end
    end

    return self.trigger_challenge if possible_fragments.length == 0

    highest_chance = possible_moves.values.sort[-1]
    p possible_moves
    p possible_words
    p possible_fragments
    possible_moves.each {|k, v| winning_moves << k if v == highest_chance}
    p winning_moves
    winning_moves.sample
  end

  def trigger_challenge
    puts 'Challenge'
    puts
    return true
  end

  def set_name
    puts
    puts "Enter player`s name: "
    name = gets.chomp
  end

  def ghost_status
    ghost = ' GHOST'
    ghost[0..@losses]
  end

  def losses_update
    @losses += 1
  end
end

