class Player

  attr_reader :name, :losses

  def initialize
    @name = self.set_name
    @losses = 0
  end

  def choose_move
    print 'Pick a letter(1) or challenge opponent(2): '
    char = gets.chomp
    puts
    if char == '1'
      return self.pick_letter
    elsif char == '2'
      return self.trigger_challenge 
    else
      puts 'Invalid choice. Choose 1 or 2'
      self.choose_move
    end
  end

  def pick_letter
    print 'Add a letter: '
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
