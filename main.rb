
# def get_input(file)
#    File.readlines(file)
# end

#  input = get_input(ARGV[0])

 class Life 
  attr_accessor :board

  def initialize
   @board = []
   25.times do |num|
    @board << []
    100.times do 
      @board[num] << '-'
    end
   end 
   
    board_arr = randomize_seed
    x = 10
    board_arr.each do |b|
      length = @board[x].count if @board[x]
      length ||= 0
      @board[x] = b.delete_if {|x| x == "\r" || x == "\n"}
      @board[x].unshift('-') until @board[x].count == (length + 1) - (length/2) 
      @board[x] << '-' until @board[x].count == length 

      x += 1 
    end

  end

  def randomize_seed
    length = rand(5..10)
     arr = []
    char =['-', 'X']
    length.times do |num|
      arr << []
      length.times do 
        arr[num]  << char[rand(0..1)]
      end
    end
    arr
  end

  def mark_dead_and_newborn(x, y)
    orgs_count = 0
    surrounding_spaces(x, y).each do |coords|

      orgs_count += 1 if ['X', '*'].include?(@board[coords[0]][coords[1]])

    end

     if (orgs_count < 2 || orgs_count > 3) && @board[x][y] == 'X'
      @board[x][y] = '*'
     elsif orgs_count == 3 && @board[x][y] == '-'
       @board[x][y] = '$'
     end

  end

  def surrounding_spaces(x, y)
 
    above_3 = [[x - 1, y - 1], [x - 1, y], [x - 1, y + 1]]
    bottom_3 = [[x + 1, y - 1], [x + 1, y], [x + 1, y + 1]]
    left_right = [[x, y - 1], [x, y + 1]]
    spaces =  (above_3 + bottom_3 + left_right)
  end


  def commit_changes
   
    @board.each_with_index do |arr, ind|
      
     
      arr.each_index.select{|i| (arr[i] == '*' || arr[i] == '$')}.each do |e|
         @board[ind][e] = @board[ind][e] == '*' ? '-' : 'X'
      end
    end
  end

  def to_s
     s = ''
     @board.each do |row|
       s += row.join('') + "\n\r"
     end
     s
  end

  def life_count
    count = 0
    @board.each do |b|
      count += b.select{|b| b == 'X'}.count rescue 0
    end
    count 
  end

  def turn
    @board[5..@board.count + 2].each_with_index do |b, x|
      b.each_with_index do |s, y|
        mark_dead_and_newborn(x, y)
      end
    end
    commit_changes
  end

 end
 
 def solution
   board = Life.new
   count = ""
   clear_code = %x{clear}
   num = ARGV[0] || 50
   num.to_i.times do |num|
    board.turn
    sleep 0.5
    print clear_code
    print board.to_s
    
    count += " " + board.life_count.to_s
   end
   count.strip
 end 

 

 solution 