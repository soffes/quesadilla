# String additions
class String
  # Truncate method from ActiveSupport.
  # @param truncate_at [Fixnum] number of characters to truncate after
  # @param options [Hash] optional options hash
  # @option options separator [String] truncate text only at a certain separator strings
  # @option options omission [String] string to add at the end to endicated truncated text. Defaults to '...'
  # @return [String] truncated string
  def q_truncate(truncate_at, options = {})
    return dup unless length > truncate_at

    options[:omission] ||= '...'
    length_with_room_for_omission = truncate_at - options[:omission].length
    stop = \
      if options[:separator]
        rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission
      else
        length_with_room_for_omission
      end

    self[0...stop] + options[:omission]
  end
end
