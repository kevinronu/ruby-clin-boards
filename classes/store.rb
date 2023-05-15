require "terminal-table"
require "json"
require_relative "card"
require_relative "list"
require_relative "board"

class Store
  attr_reader :boards

  def initialize(filename)
    @filename = filename
    @boards = load
  end

  def update_board(id:, data:)
    board = find_board(id)
    board.update(**data)
    save
  end

  def add_board(board_data)
    @boards << Board.new(**board_data)
    save
  end

  def find_board(id)
    @boards.find { |board| board.id == id }
  end

  def delete_board(id)
    @boards.delete_if { |board| board.id == id }
    save
  end

  def array_lists_name(board_id)
    board = find_board(board_id)
    board.lists.map(&:name)
  end

  def boards_table
    table = Terminal::Table.new
    table.title = "CLIn Boards"
    table.headings = ["ID", "Name", "Description", "List(#cards)"]
    table.rows = @boards.map(&:to_a)

    table # String
  end

  def lists_table(board_id)
    board = find_board(board_id)

    board.lists.each do |list|
      table = Terminal::Table.new
      table.title = list.name
      table.headings = ["ID", "Title", "Members", "Labels", "Due Date", "Checklist"]
      table.rows = list.cards.map(&:to_a)
      puts table
    end
  end

  private

  def load
    boards_data = JSON.parse(File.read(@filename), symbolize_names: true)
    boards_data.map { |board_data| Board.new(**board_data) }
  end

  def save
    File.write(@filename, JSON.pretty_generate(@boards))
  end
end
