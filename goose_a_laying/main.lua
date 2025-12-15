function main ()

  local i = 1
  local store = {}
  for line in io.lines("input.txt") do
    store[i] = line
    i = i + 1
  end

  local operands = {}
  local operandsStr = {}
  local operators  = {}
  local operatorIndices = {}

  -- Three-for-one: extract individual operators, their index in the string
  -- (which will give us column width calculations), and initialize the operand
  -- table to hold nested column-wise tables of numbers
  local i = 1
  local operatorIdx = 1
  operatorRowStr = store[#store]
  while operatorIdx do -- while we're still finding operators (not nil)
    operandsStr[i] = {}
    operatorIndices[i] = operatorIdx
    operators[i] = operatorRowStr:sub(operatorIdx, operatorIdx)

    local nextIdx = operatorRowStr:find("[%*|%+]", operatorIdx+1)
    if nextIdx then
      operatorIdx = nextIdx
      i = i + 1
    else
      -- Add a sort of "sentinel" index in order to calculate the width of the last row
      operatorIndices[i+1] = #operatorRowStr + 2
      break;
    end
  end

  -- Populate the individual column-wise tables with raw string values (and
  -- whatever whitespace padding. It'll be usefull ;) )
  for j = 1, #store - 1 do
    for i = 1, #operandsStr do
      operandsStr[i][j] = store[j]:sub(operatorIndices[i], operatorIndices[i+1] - 2)
    end
  end

  -- TODO: There's gotta be a better way to create nested zeroed-out tables via
  -- metatables and default values or something?, so this loop would be unnecessary.
  -- I'm coming off 36 hours having ever since touched Lua. Maybe somehow do it in
  -- that "three-for-one" above?
  for i = 1, #operandsStr do
    operands[i] = {}
    for j = 1, #store - 1 do
      for k = 1, #operandsStr[i][j] do
        operands[i][k] = 0
      end
    end
  end

  -- Now the fun part! Some dimensional transformation to go from left-to right,
  -- top-to-bottom human math to top-to-bottom, right-to-left cephalopod math, e.g.
  --
  --        Human:|   Cephalopod:
  --         1→2→3|       1  2  3
  --              |          ↓  ↓
  --           4→5|          4  5
  --              |             ↓
  --             6|             6
  --         +    |       +
  --         ------       -------
  -- (123 + 45 +6) (356 + 24 + 1)
  --
  -- (at least '+' and '*' are commutative, so operand order doesn't matter)
  for i = 1, #operandsStr do
    for j = 1, #store - 1 do
      for k = 1, #operandsStr[i][j] do
        number = operandsStr[i][j]:sub(k, k)
        if number ~= ' ' then -- and that's why we kept the whitespaces in the string
          operands[i][k] = operands[i][k] * 10 + number
        end
      end
    end
  end

  local total = 0
  for i = 1, #operands do
    total = total + reduce(operands[i], operators[i])
  end

  print(total) -- retrospect: hfs I can't believe that actually worked!
end

function reduce (operands, operator)
  if (operator == "*") then
    return product(operands)
  else -- operator == "+"
    return sum(operands)
  end
end

function sum (operands)
  total = 0
  for _, operand in ipairs(operands) do
    total = total + operand
  end
  return total
end

function product (operands)
  total = 1
  for _, operand in ipairs(operands) do
    total = total * operand
  end
  return total
end

main()
