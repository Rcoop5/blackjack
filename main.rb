# Blackjack terminal game

system 'clear'

# The method that I had to borrow. This is currently a sticking point for me
def calculate_total(cards)
  arr = cards.map{|e| e[1] }

  total = 0
  arr.each do |value|
    if value == "A"
      total += 11
    elsif value.to_i == 0 # J, Q, K
      total += 10
    else
      total += value.to_i
    end
  end

  #correct for Aces
  arr.select{|e| e == "A"}.count.times do
    total -= 10 if total > 21
  end

  total
end

# The method for single player
def game1(player1_cards, player1_value, dealer_cards, dealer_value)
"""Hello, here are your first cards:
#{player1_cards}for a total of #{player1_value}
Here are the dealers cards:
#{dealer_cards} for a total of #{dealer_value}

"""
end

# The method for multiplayer
def game2(player1_cards, player1_value, player2_cards, player2_value, dealer_cards, dealer_value)
"""Hello player1, here are your cards:
#{player1_cards}for a total of #{player1_value}

Hello player2, here are your cards:
#{player2_cards}for a total of #{player2_value}

Here are the dealers cards:
#{dealer_cards} for a total of #{dealer_value}

"""
end

def play_again
  puts "Play again? (y/n)"
  user_continue = gets.chomp.downcase
  system 'clear'
  start_game if user_continue == "y" else exit
end

# This greeting stays at the top of the game
def greeting
  """
Welcome to Blackjack!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The object of the game is to beat the dealer.
Beat the dealer by getting blackjack(21) or by getting a higher value
Careful! If you draw higher than 21, you lose!
Aces count as 1 or 11, dealer stands on 17
Choose between single player or multiplayer. In multiplayer both are vs dealer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Enter 1 for single player or 2 for multiplayer:"""
end

# Game is put inside this method to enable it to be played again with play_again method
def start_game
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'A', 'J', 'Q', 'K']
  suits = ['♦','♣','♥','♠']
  deck = suits.product(cards)
  deck.shuffle!

  player1_cards = deck.sample(2)
  player2_cards = deck.sample(2)
  dealer_cards = deck.sample(2)
  player1_value = calculate_total(player1_cards)
  player2_value = calculate_total(player2_cards)
  dealer_value = calculate_total(dealer_cards)

  puts greeting
  gametype = gets.chomp
  if gametype == '1'
    puts game1(player1_cards, player1_value, dealer_cards, dealer_value)
  elsif gametype == '2'
    puts game2(player1_cards, player1_value, player2_cards, player2_value, dealer_cards, dealer_value)
  elsif gametype == !['1','2']
    puts "Choose 1 or 2"
  end

  while gametype == '1' && player1_value < 21
    puts 'Would you like to 1) hit or 2) stay?'
    hit_or_stay = gets.chomp

    if hit_or_stay == '1'
      player1_cards << deck.pop
      player1_value = calculate_total(player1_cards)
      puts "You have #{player1_cards} for a total of: #{player1_value}"
    elsif hit_or_stay == '2'
      puts 'You stayed.'
      break
    else
      puts 'That is an incorrect choice'
    end

    if player1_value > 21
      puts 'You busted!'
      puts play_again
    end
  end

  while gametype == '1' && (dealer_value < 17) || (dealer_value < player1_value)
    dealer_cards << deck.pop
    dealer_value = calculate_total(dealer_cards)
    puts "Dealer hit and has #{dealer_cards} for a total of: #{dealer_value}"

    if dealer_value > 21
      puts 'Dealer busted, you win!'
      puts play_again
    end
  end

  while gametype == '2' && player1_value < 21
    puts 'Player1, would you like to 1) hit or 2) stay?'
    hit_or_stay = gets.chomp

    if hit_or_stay == '1'
      player1_cards << deck.pop
      player1_value = calculate_total(player1_cards)
      puts "You have #{player1_cards} for a total of: #{player1_value}"
    elsif hit_or_stay == '2'
      puts 'You stayed.'
      break
    else
      puts 'That is an incorrect choice'
    end

    if player1_value > 21
      puts 'You busted!'
      break
    end
  end

  while gametype == '2' && player2_value < 21
    puts 'Player2, would you like to 1) hit or 2) stay?'
    hit_or_stay = gets.chomp

    if hit_or_stay == '1'
      player2_cards << deck.pop
      player2_value = calculate_total(player2_cards)
      puts "You have #{player2_cards} for a total of: #{player2_value}"
    elsif hit_or_stay == '2'
      puts 'You stayed.'
      break
    else
      puts 'That is an incorrect choice'
    end

    if player2_value > 21
      puts 'You busted!'
    end
  end

  while gametype == '2' && (dealer_value < 17) && (dealer_value < player1_value) && (dealer_value < player2_value)
    dealer_cards << deck.pop
    dealer_value = calculate_total(dealer_cards)
    puts "Dealer hit and has #{dealer_cards} for a total of: #{dealer_value}"

    if dealer_value > 21
      puts 'Dealer busted, player(s) win!'
      puts play_again
    end
  end

  #deciding the winner

  while gametype == '1'
    if player1_value < 22 && player1_value > dealer_value
      puts "player1 wins!"
      puts play_again
    elsif player1_value < 22 && dealer_value == player1_value
      puts "Player1 & Dealer have tied!"
      puts play_again
    elsif dealer_value < 22 && dealer_value > player1_value
      puts "Dealer wins!"
      puts play_again
    end
  end

  while gametype == '2'
    if player1_value > dealer_value && player1_value > player2_value && player1_value < 22 && player2_value < 22 && dealer_value < 22
      puts "player1 wins!"
      puts play_again
    elsif player1_value > dealer_value && player1_value == player2_value && player1_value < 22 && player2_value < 22 && dealer_value < 22
      puts "Player1 & Player2 have tied!"
      puts play_again
    elsif player1_value == dealer_value && player1_value == player2_value && player1_value < 22 && player2_value < 22 && dealer_value < 22
      puts "It's a tie for all!"
      puts play_again
    elsif player1_value == dealer_value && player1_value > player2_value && player1_value < 22 && player2_value < 22 && dealer_value < 22
      puts "Player1 & Dealer have tied!"
      puts play_again
    elsif player2_value > dealer_value && player2_value > player1_value&& player1_value < 22 && player2_value < 22 && dealer_value < 22
      puts "Player2 wins!"
      puts play_again
    elsif player2_value == dealer_value && player2_value > player1_value && player1_value < 22 && player2_value < 22 && dealer_value < 22
      puts "Player2 & Dealer have tied!"
      puts play_again
    elsif dealer_value > player1_value && dealer_value > player2_value && player1_value < 22 && player2_value < 22 && dealer_value < 22
      puts "Dealer wins!"
      puts play_again
    end
  end
end

# Where the game starts
start_game
