module Utils
  # def get_input(prompt:, msg: "", required: true)
  #   puts prompt
  #   print "> "
  #   input = gets.chomp
  #   return input unless required

  #   while input.empty?
  #     puts msg
  #     puts prompt
  #     print "> "
  #     input = gets.chomp
  #   end
  #   input
  # end

  # def print_options(options)
  #   options.each.with_index do |option, index|
  #     print "#{index + 1}. #{option.capitalize}      "
  #   end
  #   puts ""
  # end

  # def get_with_options(prompt:, options:, msg: "", capitalize: false)
  #   puts prompt
  #   print_options(options)
  #   print "> "
  #   input = gets.chomp.downcase
  #   input = input.capitalize if capitalize
  #   until options.include?(input)
  #     puts msg
  #     print_options(options)
  #     print "> "
  #     input = gets.chomp.downcase
  #     input = input.capitalize if capitalize
  #   end
  #   puts ""
  #   input
  # end

  def print_welcome
    puts "####################################\n" \
         "#      Welcome to CLIn Boards      #\n" \
         "####################################\n\n"
  end

  def print_exit
    puts "####################################\n" \
         "#   Thanks for using CLIn Boards   #\n" \
         "####################################"
  end

  def print_board_options
    puts "Board options: create | show ID | update ID | delete ID\nexit"
    print "> "
  end

  def print_list_card_options
    puts "List options: create-list | update-list LISTNAME | delete-list LISTNAME\n" \
         "Card options: create-card | checklist ID | update-card ID | delete-card ID\nback"
    print "> "
  end

  def print_checklist_options
    puts "Checklist options: add | toggle INDEX | delete INDEX\nback"
    print "> "
  end
end
