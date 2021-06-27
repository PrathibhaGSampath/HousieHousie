require 'byebug'

class TicketGenerator

  attr_accessor :ticket

  BLANK_INDEX_COUNT = 4
  NUMBER_OF_TICKET_ROWS = 3
  NUMBER_OF_TICKET_COLUMNS = 9

  def generate_new_ticket
    create_a_ticket
    validate_ticket
  end

  def create_a_ticket
    self.ticket = Array.new(NUMBER_OF_TICKET_ROWS) { Array.new }
    NUMBER_OF_TICKET_COLUMNS.times do |col_num|
      row = []
      rand_num = nil
      pre_num = nil
      NUMBER_OF_TICKET_ROWS.times do |row_num|
        unless pre_num == 0
          while pre_num == rand_num
            rand_num = column_random_num(col_num, rand_num)
          end
        end
        ticket[row_num] << rand_num
        pre_num = rand_num
      end
    end
  end

  def validate_ticket
    ticket.each_with_index do |row, row_index|
      blank_indices_count = row.count(0)
      if blank_indices_count < BLANK_INDEX_COUNT
        
        add_blank_indices(row, row_index, blank_indices_count)

      elsif blank_indices_count > BLANK_INDEX_COUNT

        add_rand_num_indices(row, row_index, blank_indices_count)

      end
    end
  end

  protected
  def get_column_limits(col_num)
    lower_limit, upper_limit = 0, 0
    if col_num < NUMBER_OF_TICKET_COLUMNS
      lower_limit = col_num == 0 ? 1 : col_num*10
      if col_num == 0
        upper_limit = col_num + 9
      else
        upper_limit = (col_num == NUMBER_OF_TICKET_COLUMNS - 1 ) ? lower_limit + 10 : lower_limit + 9
      end
      
    end
    {low: lower_limit, high: upper_limit}
  end

  private
  def add_blank_indices(row, row_index, blank_indices_count)
    remaining_blank_count = BLANK_INDEX_COUNT - blank_indices_count
    
    existing_blank_indices = row.each_index.select{|i| row[i] == 0}
    if row_index == NUMBER_OF_TICKET_ROWS - 1
      existing_blank_indices += get_last_rows_blank_indices(row_index)
    end
    
    new_blank_indices = generate_random_sample(remaining_blank_count, existing_blank_indices)
    if !new_blank_indices.empty?
      update_blank_indices(row, row_index, new_blank_indices)
    end
  end

  def get_last_rows_blank_indices(row_index)
    indx = row_index - 1
    indices = []
    while indx != -1
      prev_indices = ticket[indx].each_index.select{|i| ticket[indx][i] == 0}
      indices = indices.empty? ? prev_indices : (indices & prev_indices)
      indx -= 1
    end
    indices
  end

  def update_blank_indices(row, row_index, new_blank_indices)
    row.each_index do |i| 
      if new_blank_indices.include?(i)
        lower_element = row_index - 1 unless (row_index-1) < 0
        next_element = row_index + 1 unless (row_index+1) >= NUMBER_OF_TICKET_ROWS
        if !lower_element.nil? && !next_element.nil? && ticket[lower_element][i] == 0 && ticket[next_element][i] == 0
          ticket[next_element][i] = row[i]
        elsif !next_element.nil? && ticket[next_element][i] == 0
          ticket[next_element][i] = row[i]
        end
        row[i] = 0
      end
    end
  end

  def add_rand_num_indices(row, row_index, blank_indices_count)
    remaining_filled_count = blank_indices_count - BLANK_INDEX_COUNT
    existing_blank_indices = row.each_index.select{|i| row[i] == 0}
    new_indices_to_fill = generate_random_sample(remaining_filled_count, existing_blank_indices, true)

    if !new_indices_to_fill.empty?
      update_rand_num_indices(row, row_index, new_indices_to_fill)
    end
  end

  def update_rand_num_indices(row, row_index, new_indices_to_fill)
    row.each_index do |col_num| 
      if new_indices_to_fill.include?(col_num)
        indx = row_index - 1
        while indx != -1
          pre_num = ticket[indx][col_num] if ticket[indx][col_num].nonzero?
          if !pre_num.nil? && pre_num.nonzero? && row[col_num].zero?
            rand_num = column_random_num(col_num, pre_num)
            if rand_num.zero?
              pre_element_val = pre_num - 1
              ticket[indx][col_num] = pre_element_val 
              row[col_num] = pre_num
            else
              row[col_num] = rand_num
            end
          end
          if !pre_element_val.nil? && pre_element_val == pre_num
            pre_element_val -= 1
            ticket[indx][col_num] = pre_element_val
          end
          indx -= 1
        end
      end
    end
  end
  

  def column_random_num(col_num, lower_limit=nil)
    limits = get_column_limits(col_num)
    lower_limit = limits[:low] if lower_limit.nil?
    generate_random_num(lower_limit, limits[:high])
  end

  def generate_random_num(lower_limit, upper_limit)
   (lower_limit < upper_limit) ? rand(lower_limit..upper_limit) : 0
  end

  def generate_random_sample(count,existing_blank_indices, to_fill=false)
    (to_fill == true) ? existing_blank_indices.sample(count) : ((0..8).to_a - existing_blank_indices).sample(count)
  end
end
