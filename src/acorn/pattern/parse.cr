module Acorn
  class Pattern
    module Parse
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

      enum BracketState
        # No sign of a bracket
        None
        # We have an open bracket statement
        Capture
      end

      def self.call(expression)
        parts = [] of Array(Pattern)
        parts << [] of Pattern
        scanner = StringScanner.new(expression)
        escape = EscapeState::None
        union = UnionState::None
        bracket = BracketState::None

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
          elsif scanner.scan(/\./)
            apply_union(parts, union)
            pattern = Acorn::AnyPattern.new
            parts.last.push(pattern)
          elsif scanner.scan(/\[/)
            bracket = BracketState::Capture
            parts << [] of Pattern
          elsif scanner.scan(/\]/)
            if bracket == BracketState::Capture
              bracket_members = parts.pop
              first_pat = bracket_members.shift
              bracket_set = bracket_members.reduce(first_pat) { |m, pat| m.union(pat) }
              parts.last.push(bracket_set)
            else
              raise "Unexpected close bracket"
            end
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
          elsif scanner.scan(/\{(?<min>\d+)?(?<upto>,)?(?<max>\d+)?\}/)
            min = (scanner["min"]? || 0).to_i
            max = (scanner["max"]? || (scanner["upto"]? ? ANY_NUMBER : min)).to_i
            apply_number(parts, min..max)
          elsif scanner.scan(/(?<range_begin>[^\-])-(?<range_end>[^\-])/)
            union = apply_union(parts, union)
            # Range expression
            range_begin = scanner[1].char_at(0)
            range_end = scanner[2].char_at(0)
            pattern = Acorn::RangePattern.new(range_begin..range_end)
            parts.last.push(pattern)
          elsif scanner.scan(/./)
            union = apply_union(parts, union)
            push_char(parts, scanner)
          else
            raise "Failed to unpack expression #{expression},\n  Remainder: #{scanner.rest} \n  Parts: \n    #{parts.flatten.map(&.to_debug).join("\n    ")}"
          end
        end

        # If there's an open union, close it
        apply_union(parts, union)

        parts.last
      end

      private def self.apply_union(parts, union : UnionState)
        case union
        when UnionState::Capture
          union_right = parts.last.pop
          union_left = parts.last.pop
          union_both = union_left.union(union_right)
          parts.last.push(union_both)
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
        parts.last.last.occurs(number)
      end

      private def self.push_char(parts, scanner)
        character = scanner[0].char_at(0)
        parts.last.push(CharPattern.new(match: character))
      end
    end
  end
end
