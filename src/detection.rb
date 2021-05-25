class Detection
  def initialize(intruder_bitmap, detection_algorithm, column_number, line_number)
    @detection_algorithm = detection_algorithm
    @column_number = column_number
    @line_number = line_number
    @width = intruder_bitmap.first.length
    @height = intruder_bitmap.length

    @intruder_bitmap = intruder_bitmap.dup
    @current_deviation = 0
    @invalid = false
    @positive = false
  end

  def push(sample, column_number)
    return if positive? || invalid?
    return if column_number != @column_number

    line = next_bitmap_line!
    @current_deviation += @detection_algorithm.deviation(line, sample)
    @invalid = past_allowed_deviation?
    @positive = !invalid? && finished?
  end

  def positive?
    @positive
  end

  def invalid?
    @invalid
  end

  def position
    {
      x: @column_number,
      y: @line_number,
      width: @width,
      height: @height
    }
  end

  private

  def next_bitmap_line!
    @intruder_bitmap.shift
  end

  def past_allowed_deviation?
    @detection_algorithm.past_allowed_deviation?(@current_deviation)
  end

  def finished?
    @intruder_bitmap.empty?
  end
end
