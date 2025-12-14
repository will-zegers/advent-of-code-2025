function main () local i = 1
  local store = {}
  for line in io.lines("input.txt") do
    store[i] = line
    i = i + 1
  end

  local operands = {}
  local operators  = {}

  -- Begin by creating nested tables in 'operands' to hold column-wise
  -- values based on how many values we expect to see in each row
  local i = 1
  for digit_str in string.gmatch(store[1], "%d+") do
    operands[i] = {}
    i = i + 1
  end

  -- Populate the individual column-wise tables
  for j = 1, #store - 1 do
    i = 1
    for digit_str in string.gmatch(store[j], "%d+") do
      operands[i][j] = tonumber(digit_str)
      i = i + 1
    end
  end

  -- Extract our operators
  local operatorRow = store[#store]
  local squishedOpRow = operatorRow:gsub("%s", "") -- whitespace cleanup
  for i=1, #squishedOpRow do
    operators[i] = string.sub(squishedOpRow, i, i)
  end

  local total = 0
  for i = 1, #operands do
    total = total + reduce(operands[i], operators[i])
  end

  print(total)
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
