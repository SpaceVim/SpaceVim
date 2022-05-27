local x = 1

while x < 10 do
  x = x + 1
  break
end

for i = 1,3 do
  x = x + i
end

repeat
  x = x + 1
until x > 100
