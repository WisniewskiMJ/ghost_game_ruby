require 'set'
require 'byebug'
require_relative 'player'
require_relative 'ai_player'

class Game
  
  def initialize
    @ghosted = []
    @players = []
    @fragment = ''
    @dictionary = self.init_dictionary
  end

  def run
    #display game rules
    #reset game
    self.reset
    #add players
    self.add_players
    #play rounds
    while @players.length > 1
      self.play_round 
    end
    #show winner
    self.display_header
    puts
    puts "#{@players[0].name} wins!"
    puts
    #ask game over
    self.game_over?
    
  end

  def play_round
    #display header with stats
    self.display_header
    # player selects move
    puts
    puts "#{self.current_player.name}`s move"
    puts
    move = self.take_turn(self.current_player)
    #challenge
    if move == true
      self.challenge
    #add another letter
    else
      self.finished_word?(move)
    end
    self.move_ghosts
    self.next_player!
  end

  def init_dictionary
    dict = []
    File.open('dictionary.txt').each_line {|l| dict << l.chomp}
    dict.to_set
  end

  def add_players
    puts
    print "Add player(a) or start game(s): "
    choice = gets.chomp
    if choice == "a"
      puts "Human(h) or bot(b)?"
      species = gets.chomp
      if species == "h"
        @players << Player.new
      elsif species == "b"
        @players << Ai_player.new
      else
        puts "Invalid choice"
      end
      self.add_players
    elsif choice == "s" && @players.length < 2
      puts "There has to be at least two players"
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

  def display_header
    @players.sort_by {|p| p.name}.each do |player|
      puts "#{player.name}: #{player.ghost_status}"
    end
    @ghosted.sort_by {|g| g.name}.each do |ghost|
      puts "#{ghost.name}: #{ghost.ghost_status}"
    end
    puts "Letters are: #{@fragment}"
  end

  def move_ghosts
    @players.each do |player|
      if player.losses == 5
        @ghosted << @players.delete(player)
        puts "#{player.name} became ghost!"
        puts
      end
    end
  end

  def next_player!
    @players.rotate!
  end

  def take_turn(player)
    if player.instance_of?(Player)
      player.choose_move
    else
      player.compute_move(@players.length, @fragment, @dictionary)
    end
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
      @fragment = ''
    else
      puts "There are no letters yet! Choose a letter!"
      puts
      (@players.length-1).times do
        self.next_player!
      end
    end
  end

  def finished_word?(char)
    word = @dictionary.any? {|ele| @fragment + char == ele}
      if !word
        @fragment += char
        puts
      else
        puts "Word finished: #{@fragment}#{char}. #{self.current_player.name} loses point!"
        self.current_player.losses_update
        @fragment = ''
      end 
  end

  def game_over?
    puts "Play again(p) or quit game(q):"
    choose = gets.chomp
    self.run if choose == "p".downcase
    self.game_over? if choose != "q".downcase
  end

  def reset
    @players = []
    @ghosted = []
    @fragment = ''
  end

end


if __FILE__ == $PROGRAM_NAME
  new_game = Game.new
  new_game.run
end
