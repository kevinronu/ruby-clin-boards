module Forms
  def board_form
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp

    { name: name, description: description }
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
end
