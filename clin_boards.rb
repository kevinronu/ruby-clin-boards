require_relative "classes/store"
require_relative "modules/utils"
require_relative "modules/forms"

filename = ARGV.shift

class ClinBoards
  include Utils
  include Forms

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
        @store.update_board(id: id.to_i, data: data)
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

  def show_board(board_id) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
    board = @store.find_board(board_id)
    loop do
      @store.lists_table(board_id)
      print_list_card_options
      option, card_id_or_list_name = gets.chomp.split(" ", 2)
      case option
      when "create-list"
        create_list(board)
      when "update-list"
        update_list(board)
      when "delete-list"
        board.delete_list(card_id_or_list_name)
      when "create-card"
        create_card(board: board, board_id: board_id)
      when "checklist"
        show_checklist(board_id: board_id, card_id: card_id_or_list_name)
      when "update-card"
        update_card(board: board, board_id: board_id, card_id: card_id_or_list_name.to_i)
      when "delete-card"
        board.find_list_with_card(card_id_or_list_name.to_i).delete_card(card_id_or_list_name.to_i)
      when "back"
        break
      else
        puts "Invalid Option"
      end
      @store.save
    end
  end

  def create_list(board)
    data = list_form
    board.add_list(data)
  end

  def update_list(board)
    data = list_form
    board.update_list(list_name: card_id_or_list_name, data: data)
  end

  def create_card(board:, board_id:)
    list_name = list_select(board_id)
    card_data = card_form
    board.find_list(list_name).cards << Card.new(**card_data)
  end

  def update_card(board:, board_id:, card_id:)
    list_name = list_select(board_id)
    card_data = card_form
    old_list = board.find_list_with_card(card_id)
    new_list = board.find_list(list_name)
    board.update_card(card_id: card_id, card_data: card_data, new_list: new_list,
                      old_list: old_list)
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
      @store.save
    end
  end
end

if filename.nil?
  filename = "store.json"
else
  File.write(filename, "[]") unless File.exist?(filename)
end

app = ClinBoards.new(filename)
app.start
