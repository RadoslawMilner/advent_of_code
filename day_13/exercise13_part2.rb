# maybe readlines was to ambitious?
# i tried readlines, but in comparison with lines I always get fold along - which I want to vanish
# so read file, lines, remove '\n'
data1 = File.read('example.txt').lines.map { |s| s.strip }
data2 = File.read('input.txt').lines.map { |s| s.strip }
data = data2
# we need to extract 2 separate data:
# coords & folding instruction. strip is one. but 2 different outputs, 2 splits. i cannot chain it
# gather coordinates
coords = []
# iterate through read.lines
# to get only data WITHOUT fold along
data.each do |line|
  if !line.include?('fold along')
    # push it to coords
    coords << line.split(',')
  end
end
# due to weird example/input data of task, there is enter between coords and folding - remove it
coords.delete([])
# gather folding instructions
fold_instruction = []
# iterate through read.lines
data.each do |line|
  # to get only data INCLUDING folding
  if line.include?('fold along')
    # mini_array is just temporary variable *arg
    # just to pass on each line(splited)
    mini_array = line.split('=')
    # to mutli mini arrays
    # 0 index is [0]last = y & x
    # 1 index is coords of folding - which are change to integer
    fold_instruction << [mini_array.first[-1], mini_array[1].to_i]
  end
end
# due to cursed fold along. and then due to empty bracket i couldn't change to integers earlier
# so doing it now. mapping first and second index of each array of data
# the output of filter_map is very close to task content with difference of multi small arrays
coords.map! do |i|
  [i[0].to_i, i[1].to_i]
end
# iterate through folding range for BOTH axes to transfer/fold dots on the other side up
fold_instruction.each do |folding_range|
  case
  # when axis is x
  when folding_range[0] == 'x'
    coords.each do |i|
      # lol. this is the clue of this task.
      # create a mathematical formula that allows you to transfer and simultaneously add new coordinates after bending the sheet in a certain x,y-axis values
      # to transfer coords that are below folding line we need info that they are further below that line
      # so they have larger value than value of folding line
      if i[0] > folding_range[1]
        # true?, push those, create new coords, due to transfer, where:
        # first is difference between folding range and transfer( first coord=x - folding range )
        # second y = coord last
        coords << [(folding_range[1] - ( i[0] - folding_range[1] ) ), i[1]]
      end
    end
    # new coordinates the value of which does not exceed the sheet fold value
    # meaning?
    # we need to draw new coords after fold - we get a new board with new coords
    # of course new coords CANNOT have more value than folding range because its impossible
    coords = coords.select { |i| i[0] < folding_range[1] }
    # when axis is y
  when folding_range[0] = 'y'
    coords.each do |i|
      # the same for y, though reversed
      if i[1] > folding_range[1]
        coords << [i[0], (folding_range[1] - ( i[1] - folding_range[1] ) )]
      end
    end
    coords = coords.select { |i| i[1] < folding_range[1] }
  end
end
# generate board
# board must contain dots = blank spots and '#' - dots
# use last as first (our y), because... its coding world
# if we use x first and then reverse coords of '#' we will get the result still
# but it will be turned by 270 degrees left (counterclockwise)
# build board
board = []
# we are searching max y and max x
# max y = coords.max.last
# max x = coords.max.first
# range from 0 to to max y
(0..coords.max.last).each do |proxy|
  # draw blanks thanks to another max point which is max x
  # proxy ...i just need each. not need for argument
    board << ('.' * coords.max.first)
end
# draw result by using '#' according to task
coords.each do |coord|
  # coord.last = y, coord.first = x
  board[coord.last][coord.first] = '#'
end
# puts to nicer view
# print result
board.each { |line| puts line }
# => CPZLPFZL
# that was first complete exercise which simultenseouly give me small anger and it was simple, nice, pleasant
