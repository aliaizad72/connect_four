# frozen_string_literal: true

# ConnectFour: outermost class that user will interact with
class ConnectFour
  def play
    introduction
    game = Game.new
    game.play
    play_again(game)
  end

  def introduction
    banner
    puts "  Connect four of your tokens to line up consecutively in any direction.\n\n"
    puts "  At the start of the game, you will be assigned either the blue token, or the yellow token.\n\n"
    puts '  To put your token on the grid, you will need to enter a column number.'
    puts "  The token will fall down to the lowest row in the column that does not contain a token yet.\n\n"
    puts "  Whoever connects four first, wins! Have fun!\n\n"
  end

  def banner
    puts <<-HEREDOC
  =====================================================================================================

   ██████╗ ██████╗ ███╗   ██╗███╗   ██╗███████╗ ██████╗████████╗    ███████╗ ██████╗ ██╗   ██╗██████╗
  ██╔════╝██╔═══██╗████╗  ██║████╗  ██║██╔════╝██╔════╝╚══██╔══╝    ██╔════╝██╔═══██╗██║   ██║██╔══██╗
  ██║     ██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██║        ██║       █████╗  ██║   ██║██║   ██║██████╔╝
  ██║     ██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██║        ██║       ██╔══╝  ██║   ██║██║   ██║██╔══██╗
  ╚██████╗╚██████╔╝██║ ╚████║██║ ╚████║███████╗╚██████╗   ██║       ██║     ╚██████╔╝╚██████╔╝██║  ██║
   ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═╝       ╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═╝

  =====================================================================================================
    HEREDOC
  end

  def play_again(game)
    while ask_play_again == 'y'
      game.reset
      game.play
    end
    puts '  Thanks for playing!'
  end

  def ask_play_again
    print '  Do you want to play again?(y/n): '
    input = gets.chomp
    puts
    input
  end
end
