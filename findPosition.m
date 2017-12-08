function pos = findPosition(data, str)

strPos = ismember(data, str);

for pos=1:length(strPos)
   if strPos(pos) == 1
       break
   end
end
end