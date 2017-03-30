module Acorn
  class Pattern
    module Parse
      alias Steps = Array(Pattern)

      enum UnionState
        # We haven't seen a union lately:
        None
        # We saw a union operator and we need the other pattern:
        Open
        # We saw both patterns and we should join them next chance we get:
        Capture
      end

      enum EscapeState
        # We didn't see an escape:
        None
        # We consumed an escape char, the next char is escaped:
        Capture
      end

      def self.call(expression)
        parts = Steps.new
        scanner = StringScanner.new(expression)
        escape = EscapeState::None
        union = UnionState::None

        while !scanner.eos?
          # priority:
          # - consume escaped character
          # - apply modifiers to last token
          # - apply union to last 2 tokens
          # - find token

          if escape == EscapeState::Capture
            scanner.scan(/./)
            push_char(parts, scanner)
            escape = EscapeState::None
          elsif scanner.scan(/\|/)
            apply_union(parts, union)
            union = UnionState::Open
          elsif scanner.scan(/\\/)
            escape = EscapeState::Capture
          elsif scanner.scan(/\?/)
            apply_number(parts, 0..1)
          elsif scanner.scan(/\*/)
            apply_number(parts, 0..Pattern::ANY_NUMBER)
          elsif scanner.scan(/\+/)
            apply_number(parts, 1..Pattern::ANY_NUMBER)
          elsif scanner.scan(/\{(\d+)(,)?(\d+)?\}/)
            min = scanner[1].to_i
            max = if scanner[2]?
              # A comma is present
              if scanner[3]?
                scanner[3].to_i
              else
                ANY_NUMBER
              end
            else
              # No comma, it's an exact requirement
              min
            end
            apply_number(parts, min..max)
          elsif scanner.scan(/(?<range_begin>[^\-])-(?<range_end>[^\-])/)
            union = apply_union(parts, union)
            # Range expression
            range_begin = scanner[1].char_at(0)
            range_end = scanner[2].char_at(0)
            chars = (range_begin..range_end).to_a
            char_pattern = CharPattern.new(match: chars.shift)
            pattern = chars.reduce(char_pattern) do |pat, char|
              pat.union(CharPattern.new(match: char))
            end
            parts.push(pattern)
          elsif scanner.scan(/./)
            union = apply_union(parts, union)
            push_char(parts, scanner)
          else
            raise "Failed to unpack expression #{expression},\n  Remainder: #{scanner.rest} \n  Parts: \n    #{parts.map(&.to_debug).join("\n    ")}"
          end
        end

        # If there's an open union, close it
        apply_union(parts, union)

        parts
      end

      private def self.apply_union(parts, union : UnionState)
        case union
        when UnionState::Capture
          union_right = parts.pop
          union_left = parts.pop
          union_both = union_left.union(union_right)
          parts.push(union_both)
          UnionState::None
        when UnionState::Open
          UnionState::Capture
        when UnionState::None
          UnionState::None
        else
          raise "Unexpected union state: #{union}"
        end
      end

      private def self.apply_number(parts, number)
        parts.last.occurs(number)
      end

      private def self.push_char(parts, scanner)
        character = scanner[0].char_at(0)
        parts.push(CharPattern.new(match: character))
      end
    end
  end
end
