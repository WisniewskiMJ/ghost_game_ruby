require 'set'
require 'byebug'
require_relative 'player'

class Game
  
  def initialize
    @ghosted = []
    @players = []
    @fragment = ''
    @dictionary = init_dictionary
  end

  def run
    #display game rules
    #add players
    self.add_players
    #play rounds
    while @players.length > 1
      self.play_round 
      self.next_player!
      self.move_ghosts
    end
    #show winner
    puts "#{self.current_player.name} wins!"
    puts
    #ask game over
    self.game_over?
    
  end

  def play_round
    #display header with stats
    @players.sort_by {|p| p.name}.each do |player|
      puts "#{player.name}: #{player.ghost_status}"
    end
    @ghosted.sort_by {|g| g.name}.each do |ghost|
      puts "#{ghost.name}: #{ghost.ghost_status}"
    end
    puts
    puts "#{self.current_player.name}`s move"
    puts
    # player selects move
    move = self.take_turn(self.current_player)
    #challenge
    if move == true
      self.challenge
    #add another letter
    else
      self.finished_word?(move)
    end
  end

  def init_dictionary
    dict = []
    File.open('dictionary.txt').each_line {|l| dict << l.chomp}
    dict.to_set
  end

  def add_players
    print "Add player(a) or start game(s): "
    choice = gets.chomp
    if choice == "a"
      @players << Player.new
      self.add_players
    elsif choice == "s"
      self.play_round
    else
      print "Not a valid command. Choose add player(a) or start game(s): "
      self.add_players
    end
  end

  def current_player
    @players[0]
  end

  def previous_player
    @players[-1]
  end

  def move_ghosts
    @players.each do |player|
      if player.ghost == true
         @ghosted << player
      end
    end
    @players.select! {|player| player.ghost == false}
  end

  def next_player!
    puts "ROTATE!"
    @players.rotate!
  end

  def take_turn(player)
    player.choose_move
  end

  def valid_fragment?
    if @fragment.length > 0
      @dictionary.any? {|w| w.index(@fragment) == 0}
    else
      return 0
    end
  end

  def challenge 
    if valid_fragment? == true
      puts "There are words in dictionary, which start with \"#{@fragment}\". #{self.current_player.name} loses point!"
      puts
      self.current_player.losses_update
    elsif valid_fragment? == false
      puts "There are no words in dictionary, which start with \"#{@fragment}\". #{self.previous_player.name} loses point!"
      puts
      self.previous_player.losses_update
    else
      puts "There are no letters yet! Choose a letter!"
      puts
      self.play_round
    end
  end

  def finished_word?(char)
    word = @dictionary.any? {|ele| @fragment + char == ele}
      if !word
        @fragment += char
        puts "Letters are: #{@fragment}"
        puts
       self.next_player!
        self.play_round
      else
        puts "Word finished: #{@fragment}#{char}. #{self.current_player.name} loses point!"
        self.current_player.losses_update
      end 
  end

  def game_over?
    puts "Play again(p) or quit game(q):"
    choose = gets.chomp
    self.run if choose == "p".downcase
    self.game_over? if choose != "q".downcase
  end

end


if __FILE__ == $PROGRAM_NAME
  new_game = Game.new
  new_game.run
end
