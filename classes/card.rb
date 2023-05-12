class Card
  attr_reader :id, :title, :members, :labels, :due_date
  attr_accessor :checklist

  @@id_count = 0 # rubocop:disable Style/ClassVars

  def initialize(title:, members:, labels:, due_date:)
    @id = next_id(id)
    @title = title
    @members = members
    @labels = labels
    @due_date = due_date
    @checklist = []
  end

  def update(title:, members:, labels:, due_date:)
    @title = title unless title.empty?
    @members = members unless members.empty?
    @labels = labels unless labels.empty?
    @due_date = due_date unless due_date.empty?
  end

  def to_json(_arg)
    JSON.pretty_generate({
                           id: @id,
                           title: @title,
                           members: @members,
                           labels: @labels,
                           due_date: @due_date,
                           checklist: @checklist
                         })
  end

  def to_a
    [@id, @title, @members.join(", "), @labels.join(", "), @due_date, check_items.join("/")]
  end

  private

  def next_id(id)
    if id
      @@id_count = [@@id_count, id].max # rubocop:disable Style/ClassVars
      return id
    else
      @@id_count += 1 # rubocop:disable Style/ClassVars
    end
    @@id_count
  end

  def check_items
    n = 0
    @checklist.each do |list|
      n += 1 if list[:completed]
    end
    [n, @checklist.length]
  end
end