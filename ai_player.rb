class Ai_player

  attr_reader :name, :losses

  def initialize
    @name = "#{self.set_name}(comp)"
    @losses = 0
  end

  def compute_move(players_number, fragment, dictionary)
    alpha = ("a".."z").to_a
    possible_moves = []
    # winning_moves = []
    # losing_moves = []
    # possible_fragments = []
    alpha.each do |letter|
      if dictionary.any? {|word| word.index(fragment + letter) == 0}
        possible_moves << letter
        # if word[fragment.length..-1].length % players_number != 0 && word[fragment.length..-1].length > 0
          # winning_moves << letter
        # else
          # losing_moves << letter
        # end
        # possible_fragments << (fragment + letter) 
      end
    end
    p possible_moves
    # p winning_moves
    # p losing_moves
    # p possible_fragments
    possible_moves.sample
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
