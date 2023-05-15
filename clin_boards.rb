require_relative "classes/store"
require_relative "modules/utils"

filename = ARGV.shift

class ClinBoards
  include Utils

  def initialize(filename)
    @store = Store.new(filename)
  end

  def start
    print_welcome
    loop do
      puts @store.boards_table
      print_board_options
      option, id = gets.chomp.split(" ", 2)
      case option
      when "create"
        data = board_form
        @store.add_board(data)
      when "show"
        show_board(id.to_i)
      when "update"
        data = board_form
        @store.update_board(id.to_i, data)
      when "delete"
        @store.delete_board(id.to_i)
      when "exit"
        print_exit
        break
      else
        puts "Invalid Option"
      end
    end
  end

  private

  def board_form
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp

    { name: name, description: description }
  end

  def show_board(board_id)
    board = @store.find_board(board_id)
    loop do
      @store.lists_table(board_id)
      print_list_card_options
      option, card_id_or_list_name = gets.chomp.split(" ", 2)
      case option
      when "create-list"
        data = list_form
        board.add_list(data)
      when "update-list"
        data = list_form
        board.update_list(list_name: card_id_or_list_name, data: data)
      when "delete-list"
        board.delete_list(card_id_or_list_name)
      when "create-card"
        list_name = list_select(board_id)
        card_data = card_form
        board.find_list(list_name).cards << Card.new(**card_data)
      when "checklist"
        show_checklist(board_id: board_id, card_id: card_id_or_list_name)
      when "update-card"
        list_name = list_select(board_id)
        card_data = card_form
        old_list = board.find_list_with_card(card_id_or_list_name)
        new_list = board.find_list(list_name)
        update_card(card_id: card_id_or_list_name, card_data: card_data, new_list: new_list, old_list: old_list)
      when "delete-card"
        @store.delete_card(board_id, card_id_or_list_name.to_i)
      when "back"
        break
      else
        puts "Invalid Option"
      end
    end
  end

  def show_checklist(board_id:, card_id:)
    card = @store.find_board(board_id).find_card(card_id.to_i)
    loop do
      list_items(board_id: board_id, card_id: card_id)
      print_checklist_options
      option, index = gets.chomp.split(" ", 2)
      case option
      when "add"
        data = item_form
        card.add_item(data)
      when "toggle"
        card.toggle_item(index.to_i)
      when "delete"
        card.delete_item(index.to_i)
      when "back"
        break
      else
        puts "Invalid Option"
      end
    end
  end

  def list_items(board_id:, card_id:)
    card = @store.find_board(board_id).find_card(card_id.to_i)
    puts "Card: #{card.title}"
    n = 1
    card.checklist.each do |item|
      if item[:completed] == true
        puts "[x] #{n}. #{item[:title]}"
      else
        puts "[ ] #{n}. #{item[:title]}"
      end
      n += 1
    end
  end

  def list_select(board_id)
    print "Select a list: \n#{@store.array_lists_name(board_id).join(' | ')}\n> "
    gets.chomp
  end

  def list_form
    print "Name: "
    name = gets.chomp
    { name: name }
  end

  def card_form
    print "Title: "
    title = gets.chomp
    print "Members: "
    members = gets.chomp.split(", ")
    print "Labels: "
    labels = gets.chomp.split(", ")
    print "Due Date: "
    due_date = gets.chomp
    { title: title, members: members, labels: labels, due_date: due_date, checklist: [] }
  end

  def item_form
    print "Title: "
    title = gets.chomp
    { title: title, completed: false }
  end
end

if filename.nil?
  filename = "store.json"
else
  File.write(filename, "[]") unless File.exist?(filename)
end

app = ClinBoards.new(filename)
app.start
