require_relative "list"

class Board
  attr_reader :lists, :id
  attr_accessor :name, :description

  @@id_count = 0 # rubocop:disable Style/ClassVars

  def initialize(name:, description:, lists: [], id: nil)
    @id = next_id(id)
    @name = name
    @description = description
    @lists = load_lists(lists)
  end

  def update(name:, description:)
    @name = name unless name.empty?
    @description = description unless description.empty?
  end

  def add_list(list_data)
    @lists << List.new(**list_data)
  end

  def find_list(list_name)
    @lists.find { |list| list.name == list_name }
  end

  def update_list(list_name:, data:)
    list = find_list(list_name)
    list.update(**data)
  end

  def delete_list(list_name)
    @lists.delete_if { |list| list.name == list_name }
  end

  def to_json(_arg)
    JSON.pretty_generate({
                           id: @id,
                           name: @name,
                           description: @description,
                           lists: @lists
                         })
  end

  def to_a
    lists_cards = []
    @lists.each do |list|
      lists_cards << "#{list.name}(#{list.cards.length})"
    end
    [@id, @name, @description, lists_cards.join(", ")]
  end

  private

  def load_lists(lists_data)
    lists_data.map { |list_data| List.new(**list_data) }
  end

  def next_id(id)
    if id
      @@id_count = [@@id_count, id].max # rubocop:disable Style/ClassVars
      return id
    else
      @@id_count += 1 # rubocop:disable Style/ClassVars
    end

    @@id_count
  end
end
