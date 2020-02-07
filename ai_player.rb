class Ai_player

  attr_reader :name, :losses

  def initialize
    @name = "#{self.set_name}(bot)"
    @losses = 0
  end

  def compute_move(players_number, fragment, dictionary)

    alpha = ("a".."z").to_a
    winning_moves = []
    losing_moves = []
    possible_words = []
    possible_fragments = []

    alpha.each do |letter|
      dictionary.each do |word|
        if word.index(fragment + letter) == 0
          possible_words << word
          possible_fragments << fragment + letter if !possible_fragments.include?(fragment + letter)
          if word[fragment.length..-1].length % players_number == 0 && word[fragment.length..-1].length > 0
            winning_moves << letter if !winning_moves.include?(letter)
          elsif word[fragment.length..-1].length % players_number != 0
            losing_moves << letter if !losing_moves.include?(letter)
          end
        end
      end
    end

    return self.trigger_challenge if possible_fragments.length == 0

    p winning_moves
    p losing_moves
    p possible_words
    p possible_fragments
    return winning_moves.sample if winning_moves.length > 1
    losing_moves.sample
  end

  def pick_letter
    print 'Addng  a letter: '
    letter = gets.chomp
    alpha = ("a".."z").to_a
    if alpha.include?(letter.downcase)
      puts
      return letter
    else
      puts 'Not a letter. Try again.'
      puts
      self.guess
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

