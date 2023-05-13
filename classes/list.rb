require_relative "card"

class List
  attr_reader :id, :cards
  attr_accessor :name

  @@id_count = 0 # rubocop:disable Style/ClassVars

  def initialize(name:, cards: [])
    @id = next_id(id)
    @name = name
    @cards = load_cards(cards)
  end

  def update(name:)
    @name = name unless name.empty?
  end

  def to_json(_arg)
    JSON.pretty_generate({
                           id: @id,
                           name: @name,
                           cards: @cards
                         })
  end

  def to_a
    [@name]
  end

  private

  def load_cards(cards_data)
    cards_data.map { |card_data| Card.new(**card_data) }
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
