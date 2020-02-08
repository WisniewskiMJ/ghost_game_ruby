class Ai_player

  attr_reader :name, :losses, :level

  def initialize(level)
    @name = "#{self.set_name}(bot)"
    @losses = 0
    @level = level
  end

  def compute_move(players_number, fragment, dictionary)
    alpha = ("a".."z").to_a
    possible_moves = Hash.new(0)
    winning_moves = []

    alpha.each do |letter|
      dictionary.each do |word|
        if word.index(fragment + letter) == 0
          if word[fragment.length..-1].length % players_number == 0 && word[fragment.length..-1].length > 0
            possible_moves[letter] += 1
          elsif word[fragment.length..-1].length % players_number != 0
            possible_moves[letter] -= 1
          end
        end
      end
    end
    case @level
    when "e"
      return alpha.sample
    when "n"
      return self.trigger_challenge if possible_moves.length == 0
      return possible_moves.keys.sample
    when "h"
      highest_chance = possible_moves.values.sort[-1]
      possible_moves.each {|k, v| winning_moves << k if v == highest_chance}
      winning_moves.sample
    end
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

